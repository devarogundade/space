
<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="proposal_created">
                <div class="proposal_created_text">
                    <IconBox :color="'var(--primary)'" />
                    <h3>{{ $fromWei(balance[0]) }} PG <span>Balance</span></h3>
                    <h3>{{ $fromWei(balance[1]) }} PG <span>Locked</span></h3>
                </div>
                <RouterLink :to="`/app/daos/${$route.params.id}/treasury/fund`">
                    <button>Add funds</button>
                </RouterLink>
            </div>

            <div class="dao_form">
                <div class="proposals form" v-if="history.length > 0">
                    <div class="proposal" v-for="data, i in history.reverse()" :key="i">
                        <div class="proposal_info">
                            <span v-if="data.direction == 0">Added funds</span>
                            <span v-if="data.direction == 1">Removed funds</span>
                            <div class="proposal_info_time">
                                <IconClock />
                                <p>{{ $toDate(data.timestamp) }}</p>
                            </div>
                        </div>
                        <div class="proposal_head">
                            <p class="desc">{{ data.summary }}</p>
                            <h3 class="amount">{{ $fromWei(data.amount) }} PG</h3>
                            <p class="published" v-if="data.direction == 0">From <a target="_blank"
                                    :href="`https://testnet.escan.live/address/${data.from}`">{{ $shortAddress(data.from)
                                    }}</a></p>
                            <p class="published" v-if="data.direction == 1">TO <a target="_blank"
                                    :href="`https://testnet.escan.live/address/${data.to}`">{{ $shortAddress(data.to) }}</a>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="create_proposal form" v-else>
                    <img src="/images/token-transfer.svg" alt="">
                    <h3>No funds in DAO's treasure</h3>
                    <p>Ready to distribute tokens or send funds? Initiate a token transfer here. For ideas on how to
                        distribute your community's token, read our guide on token distribution.</p>
                    <RouterLink :to="`/app/daos/${$route.params.id}/treasury/fund`">
                        <button>Add funds now</button>
                    </RouterLink>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import ProgressView from './ProgressView.vue'
import IconBox from './icons/IconBox.vue'
</script>

<script>
import Treasury from '../scripts/Treasury'
import DAO from '../scripts/DAO';
import Factory from '../scripts/Factory';
export default {

    data() {
        return {
            loading: true,
            dao: null,
            balance: null,
            history: []
        };
    },
    methods: {
        getTreasury: async function () {
            const address = await Factory.resolveName(this.$route.params.id)
            this.dao = await DAO.dao(address)
            this.balance = await Treasury.getBalance(this.dao[2])
            this.loading = false

            this.getHistory()
        },
        getHistory: async function () {
            this.history = await Treasury.getHistory(this.dao[2])
        }
    },
    mounted() {
        this.getTreasury();
    }
}
</script>

<style scoped>
section {
    padding-top: 120px;
    padding-bottom: 100px;
    min-height: 100vh;
}

.dao_form {
    display: flex;
    justify-content: center;
    margin-top: 10px;
}

.form {
    width: 700px;
}

.proposal_container {
    width: 100%;
}

.proposal_created {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px;
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    width: 100%;
}

.create_proposal {
    padding: 50px;
    border-radius: 12px;
    margin-top: 16px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.create_proposal img {
    height: 260px;
    transform: scale(1.5, 1.5);
}

.create_proposal h3 {
    font-size: 24px;
    margin-top: 60px;
    color: #fff;
}

.create_proposal p {
    font-size: 16px;
    color: #999;
    margin-top: 10px;
}

.proposal {
    padding: 20px;
    border-radius: 12px;
    background-color: rgb(23 25 28 / 1);
    margin-top: 16px;
    border: 1px solid transparent;
}

.proposal:hover {
    border: 1px solid var(--primary);
}

.proposal_created_text {
    display: flex;
    align-items: center;
    gap: 16px;
}

.proposal_created_text svg {
    width: 30px;
    height: 30px;
}

.proposal_created_text h3 {
    font-size: 30px;
    font-weight: 600;
    color: #fff;
}

.proposal_created_text span {
    font-size: 16px;
    font-weight: 500;
    color: #999;
}

.proposal_created button,
.create_proposal button {
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

.create_proposal button {
    margin-top: 40px;
}

.proposal_info {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.proposal_info span {
    padding: 3px 8px;
    background-color: var(--background);
    color: #999;
    font-size: 12px;
    border-radius: 12px;
}

.proposal_info_time {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #fff;
}

.proposal_info_time svg {
    width: 18px;
    height: 18px;
}

.proposal_info_time p {
    font-size: 12px;
    font-weight: 500;
}

.proposal_head {
    margin-top: 16px;
}

.proposal_head h3 {
    font-size: 24px;
    font-weight: 600;
}

.proposal_head .desc {
    margin-top: 6px;
    font-size: 16px;
    color: #999
}

.proposal_head .amount {
    color: #fff;
}

.proposal_head .published {
    margin-top: 10px;
    font-size: 14px;
    color: #999;
    font-weight: 500;
}

.proposal_head .published a {
    color: var(--primary);
}

.proposal_vote {
    margin-top: 20px;
    background-color: var(--background);
    border-radius: 10px;
    padding: 16px;
}

.wining {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.wining p:first-child {
    font-size: 16px;
    font-weight: 600;
}

.wining p:last-child {
    font-size: 16px;
    font-weight: 600;
    color: var(--gray-dark);
}

.progress {
    background-color: var(--gray-light);
    border-radius: 12px;
    padding: 4px;
    margin: 20px 0;
}

.progress_bar {
    height: 10px;
    background-color: var(--background);
    width: 200px;
    border-radius: 12px;
}

.status {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.status p:first-child {
    font-size: 16px;
    font-weight: 600;
    color: var(--background);
}

.status p:last-child {
    font-size: 16px;
    font-weight: 600;
    color: var(--background);
}

.proposal2_container {
    width: 440px;
}
</style>