<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="create_head">
                <div class="create_head_title">
                    <p>Mint reward for member</p>
                    <p>Step {{ step }} of 1</p>
                </div>

                <div class="progress">
                    <div class="progress_bar" :style="`width: ${(step / 1) * 100}%`"></div>
                </div>

                <div class="create_head_desc" v-if="step == 1">
                    <h1>Mint Reward</h1>
                    <p>Name and define your DAO so new contributors know they've come to the right place. This information
                        is displayed on the DAO Explore page and can be changed with a vote. For ideas on DAO branding, read
                        our guide.</p>
                </div>
            </div>

            <div class="dao_form">
                <div class="form">
                    <div class="label" v-show="step == 1">
                        <p class="title">Distribute tokens</p>
                        <p class="desc">Add the wallets you'd like to distribute tokens to. If you need help distributing
                            tokens</p>
                        <div class="address_container" v-if="tokenAllocations.length > 0">
                            <div class="address_grid">
                                <p class="address_name">Address</p>
                                <p class="address_name">Tokens</p>
                                <!-- <p class="address_name">Allocation</p> -->
                                <p></p>
                            </div>
                            <div class="address_grid" v-for="allocation, i in tokenAllocations" :key="i">
                                <div class="input">
                                    <input type="text" v-model="allocation.address" placeholder="0x...">
                                </div>
                                <div class="input">
                                    <input type="number" v-model="allocation.tokens" min="0" placeholder="0"
                                        style="text-align: center;">
                                </div>
                                <!-- <div class="input">
                                    <input type="text" disabled :value="((allocation.tokens / totalSupply) * 100) + '%'"
                                        style="background-color: var(--background-gray); text-align: center;">
                                </div> -->
                                <IconTrash v-on:click="removeAllocation(i)" />
                            </div>
                            <br> <br>
                            <div class="address_grid">
                                <p class="address_name">{{ tokenAllocations.length }} Addresses</p>
                                <p class="address_name">Total: {{ totalSupply }}</p>
                                <p class="address_name"></p>
                                <p></p>
                            </div>
                        </div>
                        <button v-if="tokenAllocations.length < 1" v-on:click="addAllocation()">Add wallet</button>
                    </div>

                    <!--  -->

                    <div class="navigation">
                        <RouterLink :to="`/app/daos/${$route.params.id}/incentives`" v-if="step == 1">
                            <button>
                                <IconArrowLeft :color="'#fff'" /> Cancel
                            </button>
                        </RouterLink>

                        <button v-on:click="mint()">Mint reward
                            <IconArrowRight :color="'#fff'" />
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <ProgressPop v-show="progress" />
    </section>
</template>

<script setup>
import IconArrowLeft from './icons/IconArrowLeft.vue'
import IconArrowRight from './icons/IconArrowRight.vue'
import IconTrash from './icons/IconTrash.vue';
import ProgressPop from './ProgressPop.vue';
</script>

<script>
import { messages } from '../reactives/messages';
import DAO from '../scripts/DAO';
import Factory from '../scripts/Factory';
import Incentives from '../scripts/Incentives';
export default {
    data() {
        return {
            tokenAllocations: [
                {
                    address: "",
                    tokens: 0
                }
            ],
            address: null,
            dao: null,
            plugin: null,
            totalSupply: 0,
            step: 1,
            progress: false,
            loading: false
        };
    },
    watch: {
        tokenAllocations: {
            handler: function (newTokenAllocations) {
                this.totalSupply = 0;
                for (let index = 0; index < newTokenAllocations.length; index++) {
                    const allocation = newTokenAllocations[index];
                    this.totalSupply += allocation.tokens;
                }
            },
            deep: true
        }
    },
    methods: {
        addAllocation: function () {
            this.tokenAllocations.push({ address: "", tokens: 0 });
        },
        removeAllocation: function (index) {
            this.tokenAllocations.splice(index, 1);
        },
        getDays: function (days) {
            return days * 24 * 3600;
        },
        mint: async function () {
            this.progress = true
            try {
                const trx = await Incentives.mint(
                    this.tokenAllocations[0].address,
                    this.tokenAllocations[0].tokens,
                    this.plugin,
                    this.dao[4]
                )

                if (trx && trx.transactionHash) {
                    messages.insertMessage({
                        title: "Incentives has been minted",
                        description: "You have successfully give out reward.",
                        type: "success",
                        linkTitle: "View Trx",
                        linkUrl: `https://testnet.escan.live/tx/${trx.transactionHash}`
                    });
                }
                else {
                    messages.insertMessage({
                        title: "Failed to mint incentive",
                        description: "Please try the transaction again",
                        type: "failed"
                    });
                }
            } catch (error) {
                alert(error)
            }
        },
        initialize: async function () {
            this.address = await Factory.resolveName(this.$route.params.id)
            this.dao = await DAO.dao(this.address)
            this.plugin = await DAO.forcePlugin(this.address, 1000)
        }
    },
    mounted() {
        this.initialize()
    },
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
    border-radius: 12px;
    background-color: rgb(23 25 28 / 1);
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
    color: var(--primary);
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
    background-color: var(--background);
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

.label input {
    padding: 0 20px;
    font-size: 16px;
    font-weight: 500;
    min-height: 50px;
    border: none;
    outline: none;
    background: none;
    width: 100%;
    color: #fff;
}

input::placeholder {
    color: #fff;
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
    color: var(--gray-dark);
    font-size: 12px;
    font-weight: 500;
    margin-top: 10px;
}

.link_container {
    background-color: var(--white);
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
    background-color: #fff;
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
    grid-template-columns: 320px 260px auto;
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