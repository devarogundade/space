<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="detail_container">
                <div class="detail_head">
                    <div class="detail_head_text">
                        <h1>{{ JSON.parse(dao[0]).name }}</h1>
                        <p class="domain">{{ JSON.parse(dao[0]).subdomain }}.space.pg</p>
                        <div class="link">
                            <p>{{ `https://spacedao.online/app/daos/${$route.params.id}` }}</p>
                            <IconCopy :color="'var(--primary)'" />
                        </div>
                        <p class="detail_head_text_desc">{{ JSON.parse(dao[0]).summary }}</p>
                    </div>
                    <div class="detail_head_image">
                        <img v-if="JSON.parse(dao[0]).logo != ''" :src="JSON.parse(dao[0]).logo" alt="">
                        <!-- <img v-else src="/images/company.png" alt=""> -->
                    </div>
                </div>
                <div class="detail_tail">
                    <div class="detail_tail_options">
                        <div class="option">
                            <IconClock :color="'var(--primary)'" />
                            <p>Created on {{ $toDate(dao[6]) }}</p>
                        </div>
                        <div class="option">
                            <IconBoxTick :color="'var(--primary)'" />
                            <p>PEGO chain</p>
                        </div>
                        <div class="option">
                            <IconPeople :color="'var(--primary)'" />
                            <p>{{ members.length }} Members</p>
                        </div>
                    </div>

                    <div class="links">
                        <a v-for="link, i in JSON.parse(dao[0]).links" :href="link.link" target="_blank" :key="i">
                            {{ link.name }}
                        </a>
                        <IconStar :color="'#fff'" class="favourite" />
                    </div>
                </div>
            </div>

            <div class="dao_container">
                <div class="proposal_container">
                    <div class="proposal_created">
                        <div class="proposal_created_text">
                            <IconBox :color="'#fff'" />
                            <h3>{{ proposals.length }} <span>Proposals created</span></h3>
                        </div>
                        <RouterLink :to="`/app/daos/${$route.params.id}/proposals/create`">
                            <button>New proposal</button>
                        </RouterLink>
                    </div>

                    <div class="proposals" v-if="proposals.length > 0">
                        <RouterLink v-for="proposal, i in proposals" :key="i"
                            :to="`/app/daos/${$route.params.id}/proposals/${i + 1}`">
                            <div class="proposal">
                                <div class="proposal_info">
                                    <span :style="`background-color: ${getStatus(proposal).color};`">{{
                                        getStatus(proposal).name }}</span>
                                    <div class="proposal_info_time">
                                        <IconClock :color="'var(--primary)'" />
                                        <p>
                                            {{ $toDate(proposal.startedOn) }} — {{ $toDate(proposal.endedOn) }}
                                        </p>
                                    </div>
                                </div>
                                <div class="proposal_head">
                                    <h3>{{ JSON.parse(proposal.metadata).title }}</h3>
                                    <p class="desc">{{ JSON.parse(proposal.metadata).summary }}</p>
                                    <p class="published">Created by <a target="_blank"
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

                <div class="proposal2_container">
                    <div class="token_container" v-if="history.length == 0">
                        <img src="/images/token-transfer.svg" alt="">
                        <h3>Make your first deposit</h3>
                        <p>Begin by making your first treasury deposit. Learn more about managing a DAO treasury in this
                            guide.</p>
                        <RouterLink :to="`/app/daos/${$route.params.id}/treasury`">
                            <button>Go to Treasury</button>
                        </RouterLink>
                    </div>
                    <div class="token_container" v-else>
                        <div class="token_balance">
                            <h3>{{ $fromWei(balance[0]) }} PG <span>Balance</span></h3>
                            <h3>{{ $fromWei(balance[1]) }} PG <span>Locked</span></h3>
                        </div>
                        <RouterLink :to="`/app/daos/${$route.params.id}/treasury`">
                            <button>Go to Treasury</button>
                        </RouterLink>
                    </div>

                    <div class="member_container">
                        <div class="members_info">
                            <IconPeople :color="'#fff'" />
                            <RouterLink :to="`/app/daos/${$route.params.id}/members/mint`">
                                <button>Add members</button>
                            </RouterLink>
                        </div>

                        <div class="members_count">
                            <h3>{{ members.length }} Members</h3>
                            <p>{{ membershipPlugin }}</p>
                        </div>
                    </div>

                    <div class="members">
                        <div class="member" v-for="member, i in members" :key="i">
                            <div class="member_info">
                                <img src="/images/user.jpg" alt="">
                                <p>{{ $shortAddress(member) }}</p>
                            </div>
                            <a :href="`https://scan.pego.network/address/${member}`" target="_blank">
                                <div class="member_link">
                                    <p>{{ $fromWei(allocations[i]) }}</p>
                                    <IconOut :color="'var(--primary)'" />
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import IconCopy from './icons/IconCopy.vue';
import IconStar from './icons/IconStar.vue'
import IconClock from './icons/IconClock.vue'
import IconBox from './icons/IconBox.vue'
import IconBoxTick from './icons/IconBoxTick.vue'
import IconPeople from './icons/IconPeople.vue';
import IconOut from './icons/IconOut.vue'
import ProgressView from './ProgressView.vue';
</script>

<script>
import DAO from '../scripts/DAO'
import Factory from '../scripts/Factory'
import Governance from '../scripts/Governance';
import Members from '../scripts/Members';
import Treasury from '../scripts/Treasury';
export default {
    data() {
        return {
            loading: true,
            address: null,
            dao: null,
            proposals: [],
            members: [],
            allocations: [],
            membershipPlugin: null,
            history: [],
            balance: [0, 0],
            entries: []
        };
    },
    methods: {
        getStatus: function (proposal) {
            if (proposal.executedOn > 0) return { name: "Executed", color: "purple" }
            let now = new Date().getTime() / 1000
            if (now < proposal.startedOn) return { name: "Upcoming", color: "brown" }
            if (now >= proposal.startedOn && now < proposal.endedOn) return { name: "Ongoing", color: "green" }
            return { name: "Ended", color: "red" }
        },
        getDao: async function () {
            this.loading = true
            this.address = await Factory.resolveName(this.$route.params.id)
            this.dao = await DAO.dao(this.address)
            this.loading = false
            this.getProposals()
            this.getMembers()
            this.getHistory()
        },
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
        getProposals: async function () {
            this.proposals = await Governance.getProposals(this.dao[3])
            this.getProposalEntries()
        },
        getHistory: async function () {
            this.balance = await Treasury.getBalance(this.dao[2])
            this.history = await Treasury.getHistory(this.dao[2])
        },
        getMembers: async function () {
            this.membershipPlugin = await DAO.forcePlugin(this.address, 1000)
            const result = await Members.members(this.membershipPlugin, this.dao[5])
            this.members = result[0]
            this.allocations = result[1]
            this.loading = false
        }
    },
    mounted() {
        this.getDao();
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

.detail_container {
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
    background-color: rgb(23 25 28 / 1);
    padding: 50px;
}

.detail_head {
    gap: 100px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.detail_head_text h1 {
    font-size: 40px;
    font-weight: 600;
    color: #fff;
}

.detail_head_text .domain {
    font-size: 14px;
    margin-top: 4px;
    font-weight: 500;
    color: #eee;
}

.detail_head_text .link {
    margin-top: 6px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.link {
    color: var(--primary);
    font-size: 14px;
    font-weight: 500;
}

.detail_head_text_desc {
    font-size: 16px;
    color: #999;
    margin-top: 10px;
    font-weight: 500;
}

.detail_head_image img {
    width: 100px;
    height: 100px;
    border-radius: 50px;
    object-fit: cover;
}

.detail_tail {
    margin-top: 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.detail_tail_options {
    display: flex;
    align-items: center;
    gap: 16px;
}

.detail_tail_options .option {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #fff;
}

.links {
    display: flex;
    align-items: center;
    gap: 20px;
}

.links a {
    font-weight: 500;
    color: #fff;
}

.favourite {
    background-color: var(--background);
    padding: 10px;
    border-radius: 12px;
    width: 50px;
    height: 50px;
}

.detail_tail_options .option p {
    font-size: 12px;
    font-weight: 500;
}


.detail_tail_options .option svg {
    width: 20px;
    height: 20px;
}

.dao_container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 40px;
    margin-top: 30px;
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
    background-color: rgb(23 25 28 / 1);
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

.token_container {
    padding: 50px;
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
    background-color: rgb(23 25 28 / 1);
    width: 100%;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.token_balance {
    display: flex;
    align-items: center;
    gap: 30px;
}

.token_balance h3 {
    margin: 0 !important;
    font-size: 30px;
    font-weight: 600;
}

.token_balance span {
    font-size: 16px;
    font-weight: 500;
    color: #999;
}

.token_container img {
    height: 200px;
    transform: scale(1.5, 1.5);
}

.token_container h3 {
    font-size: 24px;
    margin-top: 50px;
    color: #fff;
}

.token_container p {
    font-size: 16px;
    color: var(--gray-dark);
    margin-top: 10px;
    color: #999;
}

.token_container button {
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
    margin-top: 30px;
}

.member_container {
    padding: 20px;
    width: 440px;
    width: 100%;
    margin-top: 16px;
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
    background-color: rgb(23 25 28 / 1);
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
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
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
    color: #fff;
}

.member_link {
    display: flex;
    align-items: center;
    gap: 4px;
}

.member_link p {
    font-size: 12px;
    font-weight: 500;
    color: var(--primary);
}

.member_link svg {
    width: 14px;
    height: 14px;
}
</style>