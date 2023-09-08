<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="member_container">
                <div class="members_info">
                    <IconPeople />
                    <RouterLink to="/app/plugins">
                        <button>Plugins Marketplace</button>
                    </RouterLink>
                </div>

                <div class="members_count">
                    <h3>DAO Settings</h3>
                    <!-- <p>Reward type: NFT</p> -->
                </div>
            </div>

            <div class="dao_form">
                <div class="members form">
                    <br> <br>
                    <h3>Membership plugin</h3>
                    <div class="member">
                        <div class="member_info">
                            <IconBoxTick :color="'var(--primary)'" />
                            <p>{{ membershipPlugin }}</p>
                        </div>
                        <div v-on:click="registerPlugin()"
                            v-if="membershipPlugin == '0x0000000000000000000000000000000000000000'" class="member_link">
                            <p>register</p>
                        </div>
                        <div v-else class="member_link" v-on:click="unRegisterPlugin(1000)">
                            <p>unregister</p>
                        </div>
                    </div>

                    <br>

                    <h3>Incentives plugin</h3>
                    <div class="member">
                        <div class="member_info">
                            <IconBoxTick :color="'var(--primary)'" />
                            <p>{{ incentivesPlugin }}</p>
                        </div>
                        <div v-on:click="registerPlugin()"
                            v-if="incentivesPlugin == '0x0000000000000000000000000000000000000000'" class="member_link">
                            <p>register</p>
                        </div>
                        <div v-else class="member_link" v-on:click="unRegisterPlugin(1003)">
                            <p>unregister</p>
                        </div>
                    </div>

                    <br>

                    <h3>Governance plugin</h3>
                    <div class="member">
                        <div class="member_info">
                            <IconBoxTick :color="'var(--primary)'" />
                            <p>{{ governanacePlugin }}</p>
                        </div>
                        <div v-on:click="registerPlugin()"
                            v-if="governanacePlugin == '0x0000000000000000000000000000000000000000'" class="member_link">
                            <p>register</p>
                        </div>
                        <div v-else class="member_link" v-on:click="unRegisterPlugin(1001)">
                            <p>unregister</p>
                        </div>
                    </div>

                    <br>

                    <h3>Treasury plugin</h3>
                    <div class="member">
                        <div class="member_info">
                            <IconBoxTick :color="'var(--primary)'" />
                            <p>{{ treasuryPlugin }}</p>
                        </div>
                        <div v-on:click="registerPlugin()"
                            v-if="treasuryPlugin == '0x0000000000000000000000000000000000000000'" class="member_link">
                            <p>register</p>
                        </div>
                        <div v-else class="member_link" v-on:click="unRegisterPlugin(1002)">
                            <p>unregister</p>
                        </div>
                    </div>
                </div>

                <div class="style">
                    <br> <br>
                    <h3>Customise</h3>
                    <div class="color">
                        <p>Background</p>
                        <ColorPicker :color="background" v-on:color-change="updateBackground" />
                    </div>
                    <div class="color">
                        <p>Text Color</p>
                        <ColorPicker :color="textColor" v-on:color-change="updateTextColor" />
                    </div>
                    <div class="label">
                        <p class="title">Font Family</p>
                        <p class="desc">Choose a font that best fits your DAO.
                        </p>
                        <select name="categories" v-on:change="pickFont">
                            <option value="'Mukta', sans-serif !important">Default</option>
                            <option value="'Poppins', sans-serif !important">Poppins</option>
                            <option value="'Montserrat', sans-serif !important">Montserrat</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <ProgressPop v-if="progress" />
    </section>
</template>

<script setup>
import ProgressView from './ProgressView.vue';
import IconBoxTick from './icons/IconBoxTick.vue';
import ProgressPop from './ProgressPop.vue'
import { ColorPicker } from 'vue-accessible-color-picker'
</script>

<script>
import DAO from '../scripts/DAO';
import { messages } from '../reactives/messages';
import Factory from '../scripts/Factory';
export default {
    data() {
        return {
            loading: true,
            dao: null,
            color: "#fff",
            progress: false,
            address: null,
            membershipPlugin: '',
            governanacePlugin: '',
            treasuryPlugin: '',
            incentivesPlugin: '',
            background: '#23262d',
            textColor: '#fff',
            font: "'Mukta', sans-serif"
        };
    },
    methods: {
        pickFont: function (e) {
            this.font = e.target.value
            document.body.style.fontFamily = this.font;
        },
        updateBackground: function (e) {
            this.background = e.cssColor
            document.body.style.backgroundColor = this.background;
        },
        updateTextColor: function (e) {
            this.textColor = e.cssColor
            // document.body.style.color = this.textColor + ' !important';
        },
        getDao: async function () {
            this.address = await Factory.resolveName(this.$route.params.id);
            this.dao = await DAO.dao(this.address);
            this.loading = false;
            this.membershipPlugin = await DAO.forcePlugin(this.address, 1000)
            this.governanacePlugin = await DAO.forcePlugin(this.address, 1001)
            this.treasuryPlugin = await DAO.forcePlugin(this.address, 1002)
            this.incentivesPlugin = await DAO.forcePlugin(this.address, 1003)
        },
        unRegisterPlugin: async function (code) {
            this.progress = true

            const trx = await DAO.unRegisterPlugin(
                code, this.address
            )

            if (trx && trx.transactionHash) {
                messages.insertMessage({
                    title: "Member has been minted",
                    description: "You have successfully addedd a new member.",
                    type: "success",
                    linkTitle: "View Trx",
                    linkUrl: `https://testnet.escan.live/tx/${trx.transactionHash}`
                });
            }
            else {
                messages.insertMessage({
                    title: "Failed to mint member",
                    description: "Please try the transaction again",
                    type: "failed"
                });
            }

            this.progress = false

            this.getDao()
        },

        registerPlugin: async function () {
            const plugin = prompt('Enter plugin contract address')

            this.progress = true

            const trx = await DAO.registerPlugin(
                plugin, this.address
            )

            if (trx && trx.transactionHash) {
                messages.insertMessage({
                    title: "Member has been minted",
                    description: "You have successfully addedd a new member.",
                    type: "success",
                    linkTitle: "View Trx",
                    linkUrl: `https://testnet.escan.live/tx/${trx.transactionHash}`
                });
            }
            else {
                messages.insertMessage({
                    title: "Failed to mint member",
                    description: "Please try the transaction again",
                    type: "failed"
                });
            }

            this.progress = false

            this.getDao()
        }
    },
    mounted() {
        this.getDao();
    }
}
</script>

<style scoped>
section {
    padding-top: 120px;
    padding-bottom: 100px;
    min-height: 100vh;
}


.member_container {
    padding: 20px;
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    width: 100%;
    margin-top: 16px;
}

.members_info {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.members_count {
    margin-top: 40px;
}

.members_count h3 {
    font-size: 30px;
    font-weight: 600;
    color: #fff;
}

.members_count p {
    font-size: 16px;
    font-weight: 500;
    color: #999;
}

.member_container button {
    background-color: var(--primary);
    color: #fff;
    border-radius: 12px;
    height: 45px;
    padding: 0 16px;
    display: flex;
    align-items: center;
    font-size: 16px;
    border: none;
    font-weight: 500;
    cursor: pointer;
}

.member {
    padding: 20px;
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    width: 440px;
    width: 100%;
    margin-top: 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border: 1px solid transparent;
}

.member:hover {
    border: 1px solid var(--primary);
}

.dao_form {
    display: flex;
    justify-content: center;
    margin-top: 10px;
    gap: 40px;
}

.form {
    width: 700px;
}

.form h3 {
    color: #fff;
    font-size: 22px;
    font-weight: 500;
    text-decoration: underline 1px;
}

.style h3 {
    color: #fff;
    font-size: 22px;
    font-weight: 500;
    text-decoration: underline 1px;
}

.color {
    margin-top: 10px;
}

.color p {
    color: #999;
}

.member_info {
    display: flex;
    align-items: center;
    gap: 16px;
}

.member_info img {
    width: 24px;
    height: 24px;
    border-radius: 12px;
    object-fit: cover;
}

.member_info p {
    font-size: 16px;
    font-weight: 600;
    color: #eee;
}

.member_link {
    display: flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
    user-select: none;
    background: var(--background);
    border-radius: 6px;
    padding: 6px 10px;
}

.member_link p {
    font-size: 14px;
    font-weight: 500;
    color: var(--primary);
}

.member_link svg {
    width: 14px;
    height: 14px;
}

.style {
    width: 400px;
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

.label input,
select,
textarea {
    padding: 0 20px;
    font-size: 16px;
    font-weight: 500;
    min-height: 50px;
    border: none;
    outline: none;
    background: none;
    color: #fff;
    width: 100%;
}

select {
    /* border: 2px solid rgb(228, 231, 235); */
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    /* background-color: var(--white); */
    overflow: hidden;
    margin-top: 10px;
    display: flex;
    align-items: center;
}
</style>