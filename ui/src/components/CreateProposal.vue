<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="create_head">
                <div class="create_head_title">
                    <p>Create your DAO proposal</p>
                    <p>Step {{ step }} of 1</p>
                </div>

                <div class="progress">
                    <div class="progress_bar" :style="`width: ${(step / 1) * 100}%`"></div>
                </div>

                <div class="create_head_desc" v-if="step == 1">
                    <h1>Describe your proposal</h1>
                    <p>Name and define your DAO so new contributors know they've come to the right place. This information
                        is displayed on the DAO Explore page and can be changed with a vote. For ideas on DAO branding, read
                        our guide.</p>
                </div>
            </div>

            <div class="dao_form">
                <div class="form">
                    <div class="label" v-show="step == 1">
                        <p class="title">Proposal title</p>
                        <p class="desc">Maximum of 128 characters</p>
                        <div class="input">
                            <input v-model="proposal.title" type="text" placeholder="Type your DAO's name...">
                        </div>
                        <p class="count">{{ proposal.title.length }}/128</p>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Proposal summary</p>
                        <p class="desc">Describe your DAO's purpose in a few sentences. This is listed on the Explore page
                            so new contributors can find you.
                        </p>
                        <div class="input">
                            <textarea v-model="proposal.summary" rows="5" type="text"
                                placeholder="Type your summary..."></textarea>
                        </div>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Use funds from treasure <input type="checkbox" v-model="useFund" /></p>
                        <p class="desc" v-if="useFund">The current treasure balance is {{ $fromWei(balance[0]) }}
                            PG</p>
                        <div class="input" v-if="useFund">
                            <input v-model="proposal.treasureAmount" type="number" placeholder="0.00">
                        </div>
                        <br>
                        <p class="title" v-if="useFund">Write a summary about using this funds</p>
                        <div class="input" v-if="useFund">
                            <input v-model="proposal.treasureSummary" type="text" placeholder="Write summary..">
                        </div>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Start voting on</p>
                        <p class="desc">Specify a time in the future to open proposal voting.</p>
                        <br>
                        <VueDatePicker v-model="proposal.startedOn" />
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">End voting on</p>
                        <p class="desc">Specify a time in the future to end proposal voting.</p>
                        <br>
                        <VueDatePicker v-model="proposal.endedOn" />
                        <p class="count">Must be at least {{ minDuration }} days interval</p>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Links <span>Optional</span></p>
                        <p class="desc">Links to your proposal's website, social media profiles, Discord, or other places
                            your
                            community gathers.</p>
                        <div class="link_container" v-if="proposal.links.length > 0">
                            <div class="link_grid">
                                <p class="link_name">Name / Description</p>
                                <p class="link_name">Link</p>
                                <p></p>
                            </div>
                            <div class="link_grid" v-for="link, i in proposal.links" :key="i">
                                <div class="input">
                                    <input type="text" v-model="link.name" placeholder="Medium, Discord, etc.">
                                </div>
                                <div class="input">
                                    <input type="text" v-model="link.link" placeholder="https://">
                                </div>
                                <IconTrash v-on:click="removeLink(i)" />
                            </div>
                        </div>
                        <button v-if="proposal.links.length < 5" v-on:click="addLink()">Add link</button>
                    </div>

                    <!--  -->

                    <div class="navigation">
                        <RouterLink :to="`/app/daos/${$route.params.id}`" v-if="step == 1">
                            <button>
                                <IconArrowLeft :color="'#fff'" /> Cancel
                            </button>
                        </RouterLink>

                        <button v-on:click="create()">Create proposal
                            <IconArrowRight :color="'#fff'" />
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <ProgressPop v-if="creating" />
    </section>
</template>

<script setup>
import ProgressPop from './ProgressPop.vue'
import IconArrowLeft from './icons/IconArrowLeft.vue'
import IconArrowRight from './icons/IconArrowRight.vue'
import IconTrash from './icons/IconTrash.vue'
</script>

<script>
import Factory from '../scripts/Factory'
import Governance from '../scripts/Governance'
import DAO from '../scripts/DAO'
import Treasury from '../scripts/Treasury'
import { messages } from '../reactives/messages';
export default {
    data() {
        return {
            proposal: {
                title: "",
                summary: "",
                treasureAmount: 0,
                treasureSummary: "",
                startedOn: new Date(),
                endedOn: new Date(),
                links: [
                    {
                        name: '',
                        link: ''
                    }
                ],
            },
            address: null,
            creating: false,
            useFund: false,
            step: 1,
            dao: null,
            balance: [0, 0],
            minDuration: 1
        };
    },
    watch: {
        useFund: function () {
            this.proposal.treasureAmount = "";
        }
    },
    methods: {
        addLink: function () {
            this.proposal.links.push({ name: '', link: '' })
        },

        removeLink: function (index) {
            this.proposal.links.splice(index, 1)
        },

        getDao: async function () {
            this.address = await Factory.resolveName(this.$route.params.id)
            this.dao = await DAO.dao(this.address)
            this.balance = await Treasury.getBalance(this.dao[2])
            this.minDuration = await Governance.minDuration(this.dao[3])
            const time = (this.proposal.startedOn.getTime() + (this.minDuration * 24 * 60 * 60 * 1000))
            this.proposal.endedOn = new Date(time)
        },

        create: async function () {
            if (this.proposal.title == '') {
                alert('Enter proposal title')
                return
            }
            if (this.proposal.summary == '') {
                alert('Enter proposal summary')
                return
            }
            if (this.useFund && this.proposal.treasureAmount == 0) {
                alert('Enter treasure alloction')
                return
            }
            if (this.useFund && this.proposal.treasureSummary == '') {
                alert('Enter treasure summary')
                return
            }
            for (let index = 0; index < this.proposal.links.length; index++) {
                const link = this.proposal.links[index];
                if (link.name == '' || !link.link.startsWith('http')) {
                    alert('Enter a valid link name and url')
                    return
                }
            }
            if (confirm('Confirm to create proposal')) {
                this.creating = true

                const metadata = {
                    title: this.proposal.title,
                    summary: this.proposal.summary,
                    links: this.proposal.links
                }

                const trx = await Governance.createProposal(
                    JSON.stringify(metadata),
                    (this.proposal.startedOn.getTime() / 1000).toFixed(0),
                    (this.proposal.endedOn.getTime() / 1000).toFixed(0),
                    this.$toWei(this.proposal.treasureAmount),
                    this.proposal.treasureSummary,
                    this.address
                )

                if (trx && trx.transactionHash) {
                    messages.insertMessage({
                        title: "Your proposal has been created",
                        description: "You have successfully created a new proposal.",
                        type: "success",
                        linkTitle: "View Trx",
                        linkUrl: `https://testnet.escan.live/tx/${trx.transactionHash}`
                    });
                }
                else {
                    messages.insertMessage({
                        title: "Failed to create proposal",
                        description: "Please try the transaction again",
                        type: "failed"
                    });
                }

                this.creating = false
            }
        }
    },
    mounted() {
        this.getDao()
    }
}
</script>

<style scoped>
section {
    background-color: var(--background-gray);
    padding-top: 120px;
    padding-bottom: 100px;
    min-height: 100vh;
}

.create_head {
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    padding: 50px;
}

.create_head_title {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-weight: 600;
}

.create_head_title p:first-child {
    color: #fff;
}

.create_head_title p:last-child {
    color: var(--primary);
}

.progress {
    background-color: #fff;
    border-radius: 12px;
    margin: 20px 0;
}

.progress_bar {
    height: 10px;
    background-color: var(--primary);
    border-radius: 12px;
    transition: .1s;
}

.create_head_desc h1 {
    margin-top: 20px;
    font-size: 40px;
    font-weight: 600;
    color: #fff;
}


.create_head_desc p {
    font-size: 20px;
    color: #999;
    font-weight: 500;
}

.dao_form {
    display: flex;
    justify-content: center;
    margin-top: 10px;
}

.form {
    width: 700px;
}

.label {
    margin-top: 40px;
}

.label .title {
    font-size: 16px;
    font-weight: 600;
    color: #fff;
}

.label .title span {
    font-size: 14px;
    color: #999;
    margin-left: 4px;
}

.label .desc {
    font-size: 14px;
    font-weight: 500;
    color: #999;
    margin-top: 6px;
}

.label .input {
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    overflow: hidden;
    margin-top: 10px;
    display: flex;
    align-items: center;
    cursor: pointer;
}

input,
textarea {
    color: #fff;
}

input::placeholder {
    color: #999;
}

.input_file {
    width: 80px;
    height: 80px;
    margin-top: 10px;
    border: 2px dashed rgb(228, 231, 235);
    border-radius: 12px;
    background-color: var(--white);
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
}

.nft_input_file {
    width: 280px;
    height: 300px;
}

.input_file svg {
    width: 30px;
    height: 30px;
}

.input_file input {
    width: 100%;
    position: absolute;
    height: 100%;
    opacity: 0;
}

.label .input_tag {
    background-color: var(--background-gray);
    padding: 10px 20px;
    min-width: 100px;
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: var(--black);
    font-weight: 500;
    font-size: 16px;
}

.label input[type=text],
.label input[type=number] {
    padding: 0 20px;
    font-size: 16px;
    font-weight: 500;
    min-height: 50px;
    border: none;
    outline: none;
    background: none;
    width: 100%;
}

.label textarea {
    padding: 12px 20px;
    font-size: 16px;
    font-weight: 500;
    border: none;
    outline: none;
    background: none;
    width: 100%;
    resize: none;
}

.label .count {
    color: #999;
    font-size: 12px;
    font-weight: 500;
    margin-top: 10px;
}

.link_container {
    background-color: #fff;
    border-radius: 12px;
    padding: 16px;
    margin-top: 16px;
}

.link_grid {
    display: grid;
    grid-template-columns: 300px 300px auto;
    gap: 20px;
    align-items: center;
}

.link_grid svg {
    margin-top: 10px;
    cursor: pointer;
}

.link_name {
    font-size: 18px;
    font-weight: 500;
}

.label button {
    background-color: var(--primary);
    border-radius: 12px;
    height: 45px;
    padding: 0 16px;
    display: flex;
    align-items: center;
    color: #fff;
    font-size: 16px;
    border: none;
    font-weight: 500;
    cursor: pointer;
    margin-top: 10px;
}

.navigation {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 60px;
}

/* ////////////////// */

.participate_options .option {
    margin-top: 16px;
    border: 2px solid rgb(228, 231, 235);
    padding: 16px 20px;
    border-radius: 12px;
    display: grid;
    grid-template-columns: auto 20px;
    gap: 10px;
}

.participate_options .option_active {
    border: 2px solid var(--background);
}

.option h6 {
    font-size: 16px;
    font-weight: 600;
}


.option p {
    font-size: 12px;
    font-weight: 500;
    margin-top: 6px;
}

.option_dot {
    width: 20px;
    height: 20px;
    border: 2px solid var(--gray);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.participate_options .option_active .option_dot {
    border: 2px solid var(--background);
}


.participate_options .option_active .inner_dot {
    background-color: var(--background-light);
}

.inner_dot {
    width: 12px;
    height: 12px;
    background-color: var(--gray);
    border-radius: 10px;
}

.navigation button {
    background-color: var(--primary);
    color: #fff;
    border-radius: 12px;
    height: 45px;
    padding: 0 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 16px;
    border: none;
    font-weight: 500;
    cursor: pointer;
}

.address_container {
    background-color: var(--white);
    border-radius: 12px;
    padding: 16px;
    margin-top: 16px;
}

.gasless_options {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}

.address_grid {
    display: grid;
    grid-template-columns: 280px 200px 100px auto;
    gap: 20px;
    align-items: center;
}

.address_grid svg {
    margin-top: 10px;
    cursor: pointer;
}

.address_name {
    font-size: 18px;
    font-weight: 500;
}

.specify_container {
    background-color: var(--white);
    border-radius: 12px;
    padding: 16px;
    margin-top: 16px;
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
}

.specify_container .participate_options .option {
    margin-top: 10px;
}
</style>