<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="proposal_created">
                <div class="proposal_created_text">
                    <IconBox :color="'#fff'" />
                    <h3>{{ proposals.length }} <span>Proposals created</span></h3>
                </div>
                <RouterLink :to="`/app/daos/${$route.params.id}/proposals/create`">
                    <button>New proposal</button>
                </RouterLink>
            </div>

            <div class="dao_form">
                <div class="proposals" v-if="proposals.length > 0">
                    <RouterLink v-for="proposal, i in proposals" :key="i"
                        :to="`/app/daos/${$route.params.id}/proposals/${i + 1}`">
                        <div class="proposal">
                            <div class="proposal_info">
                                <span :style="`background-color: ${getStatus(proposal).color};`">{{
                                    getStatus(proposal).name }}</span>
                                <div class="proposal_info_time">
                                    <IconClock />
                                    <p>
                                        Voting period: {{ $toDate(proposal.startedOn) }} — {{ $toDate(proposal.endedOn) }}
                                    </p>
                                </div>
                            </div>
                            <div class="proposal_head">
                                <h3>{{ JSON.parse(proposal.metadata).title }}</h3>
                                <p class="desc">{{ JSON.parse(proposal.metadata).summary }}</p>
                                <p class="published">Created by <a
                                        :href="`https://scan.pego.network/address/${proposal.creator}`">{{
                                            $shortAddress(proposal.creator)
                                        }}
                                    </a> on {{ $toDate(proposal.createdOn) }}</p>
                            </div>
                            <div class="proposal_vote">
                                <div class="wining">
                                    <p>Votes ({{ proposal.voters.length }})</p>
                                    <!-- <p>12 $SAM</p> -->
                                </div>
                                <div class="progress">
                                    <div class="progress_bar"
                                        :style="`width: ${(safeEntry(i).agrees / safeEntry(i).total) * 100}%;`"></div>
                                </div>
                                <div class="status">
                                    <p>{{ getStatus(proposal).name }}</p>
                                    <p>{{ (safeEntry(i).agrees / safeEntry(i).total) * 100 }}%</p>
                                </div>
                            </div>
                        </div>
                    </RouterLink>
                </div>

                <div class="create_proposal" v-else>
                    <img src="/images/no-proposal.svg" alt="">
                    <h3>No proposal has been created</h3>
                    <p>Ready to distribute tokens or send funds? Initiate a token transfer here. For ideas on how to
                        distribute your community's token, read our guide on token distribution.</p>
                    <RouterLink :to="`/app/daos/${$route.params.id}/proposals/create`">
                        <button>Create first proposal</button>
                    </RouterLink>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import ProgressView from './ProgressView.vue';
</script>

<script>
import DAO from '../scripts/DAO';
import Factory from '../scripts/Factory';
import Governance from '../scripts/Governance';
import IconBox from './icons/IconBox.vue';
export default {
    data() {
        return {
            proposals: [],
            loading: true,
            entries: []
        };
    },
    methods: {
        safeEntry: function (index) {
            if (index >= this.entries.length) return { agrees: 0, total: 0 }
            return this.entries[index]
        },
        getProposalEntries: async function () {
            this.entries = []
            for (let index = 1; index <= this.proposals.length; index++) {
                let entries = await Governance.getVoteEntries(index, this.dao[3]);
                let voteTypes = entries[1];
                let agrees = 0;
                for (let index = 0; index < voteTypes.length; index++) {
                    if (voteTypes[index] == 0)
                        agrees++;
                }
                this.entries.push({ agrees: agrees, total: voteTypes.length })
            }
        },
        getStatus: function (proposal) {
            if (proposal.executedOn > 0) return { name: "Executed", color: "purple" }
            let now = new Date().getTime() / 1000
            if (now < proposal.startedOn) return { name: "Upcoming", color: "brown" }
            if (now >= proposal.startedOn && now < proposal.endedOn) return { name: "Ongoing", color: "green" }
            return { name: "Ended", color: "red" }
        },
        getProposals: async function () {
            this.loading = true;
            try {
                this.address = await Factory.resolveName(this.$route.params.id);
                this.dao = await DAO.dao(this.address);
                this.proposals = await Governance.getProposals(this.dao[3]);
                this.getProposalEntries()
            } catch (error) {
                alert(error)
            }
            this.loading = false;
        }
    },
    mounted() {
        this.getProposals();
    },
    components: { IconBox }
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

.proposals {
    width: 800px;
}


.proposal_container {
    width: 800px;
}

.proposal_created {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px;
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
    background-color: rgb(23 25 28 / 1);
}

.create_proposal {
    padding: 50px;
    margin-top: 16px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
}

.create_proposal img {
    height: 260px;
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
    margin-top: 60px;
}


.proposal {
    padding: 20px;
    margin-top: 16px;
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
    background-color: rgb(23 25 28 / 1);
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
    color: #fff;
}

.proposal_created button {
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

.proposal_info {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.proposal_info span {
    padding: 3px 8px;
    background-color: var(--primary);
    color: #fff;
    font-size: 12px;
    border-radius: 12px;
}

.proposal_info_time {
    display: flex;
    align-items: center;
    gap: 6px;
}

.proposal_info_time svg {
    width: 18px;
    height: 18px;
}

.proposal_info_time p {
    font-size: 12px;
    font-weight: 500;
    color: #999;
}

.proposal_head {
    margin-top: 16px;
}

.proposal_head h3 {
    font-size: 24px;
    font-weight: 600;
    color: #fff;
}

.proposal_head .desc {
    margin-top: 6px;
    font-size: 16px;
    color: #eee;
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
    color: #fff;
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
    background-color: #fff;
    border-radius: 12px;
    margin: 20px 0;
}

.progress_bar {
    height: 10px;
    background-color: var(--primary);
    width: 200px;
    border-radius: 12px;
    width: 1%;
}

.status {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.status p:first-child {
    font-size: 16px;
    font-weight: 600;
    color: #fff;
}

.status p:last-child {
    font-size: 16px;
    font-weight: 600;
    color: var(--primary);
}

.proposal2_container {
    width: 440px;
}
</style>