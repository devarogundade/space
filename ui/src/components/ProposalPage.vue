<template>
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="proposal_container">
                <div class="title">
                    <h3>{{ JSON.parse(proposal.metadata).title }}</h3>
                    <p class="published">Created by <a :href="`https://scan.pego.network/address/${proposal.creator}`"
                            target="_blank">{{ $shortAddress(proposal.creator) }}</a></p>
                    <p class="summary">{{ JSON.parse(proposal.metadata).summary }}</p>
                    <br>
                    <div class="created_zone">
                        <p class="created">
                            <IconClock :color="'var(--primary)'" /> &nbsp; Created on {{ $toDate(proposal.createdOn) }}
                        </p>

                        <span :style="`background-color: ${getStatus(proposal).color};`">{{
                            getStatus(proposal).name }}</span>

                        <div class="links">

                            <a v-for="link, i in JSON.parse(proposal.metadata).links" :key="i" :href="link.link"
                                target="_blank">
                                {{ link.name }}
                                <IconOut :color="'var(--primary)'" />
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid_container">
                <div class="voting">
                    <div class="voting_head">
                        <h3>Voting</h3>

                        <div class="voting_head_options">
                            <!-- <p>Breakdown</p> -->
                            <p>Voters ({{ proposal.voters.length }})</p>
                        </div>
                    </div>

                    <div class="yes_vote">
                        <div class="yes_head">
                            <p>Agree</p>
                            <div class="yes_head_options">
                                <p>{{ agrees }} votes</p>
                                <p>{{ (agrees / voters.length) * 100 }}%</p>
                            </div>
                        </div>

                        <div class="progress">
                            <div class="progress_bar" :style="`width: ${(agrees / voters.length) * 100}%;`"></div>
                        </div>
                    </div>

                    <div class="yes_vote">
                        <div class="yes_head">
                            <p>Disagree</p>
                            <div class="yes_head_options">
                                <p>{{ disagrees }} votes</p>
                                <p>{{ (disagrees / voters.length) * 100 }}%</p>
                            </div>
                        </div>

                        <div class="progress">
                            <div class="progress_bar" :style="`width: ${(disagrees / voters.length) * 100}%;`"></div>
                        </div>
                    </div>

                    <div class="yes_vote">
                        <div class="yes_head">
                            <p>Abstain</p>
                            <div class="yes_head_options">
                                <p>{{ abstains }} votes</p>
                                <p>{{ (abstains / voters.length) * 100 }}%</p>
                            </div>
                        </div>
                        <div class="progress">
                            <div class="progress_bar" :style="`width: ${(abstains / voters.length) * 100}%;`"></div>
                        </div>
                    </div>

                    <br> <br>

                    <div class="voting_head">
                        <h3>Treasury allocation</h3>
                    </div>

                    <div class="voting_body" v-if="proposal.treasuryAmount > 0">
                        <p>Amount: {{ $fromWei(proposal.treasuryAmount) }} PG</p>
                        <p>{{ proposal.treasurySummary }}</p>
                    </div>

                    <div class="voting_body" v-else>
                        <p>No funds allocation from treasury.</p>
                    </div>

                    <br> <br>

                    <div class="proposal_info_time">
                        <IconClock :color="'var(--primary)'" />
                        <p>
                            {{ $toDate(proposal.startedOn) }} - {{ $toDate(proposal.endedOn) }}
                        </p>
                    </div>

                    <div class="label" v-if="!hasVoted()">
                        <h3 class="title">Enter voting power</h3>
                        <p class="desc">Minimum required voting power is {{ $fromWei(minVoting) }}</p>
                        <div class="input">
                            <input v-model="votingPower" type="number" placeholder="0 $YT" />
                        </div>
                    </div>

                    <div class="vote_actions" v-if="!hasVoted()">
                        <button v-on:click="vote(0)">Agree</button>
                        <button v-on:click="vote(1)">Disagree</button>
                        <button v-on:click="vote(2)">Abstain</button>
                    </div>

                    <div class="vote_actions2" v-if="hasVoted()">
                        <button style="background: #555; color: #000;">Already Voted</button>
                    </div>
                </div>

                <div class="token_container">
                    <img src="/images/token-transfer.svg" alt="">
                    <h3>Execute proposal</h3>
                    <p>Begin by making your first treasury deposit. Learn more about managing a DAO treasury in this
                        guide.</p>
                    <button v-if="proposal.executedOn == 0" v-on:click="execute()">Execute proposal</button>
                    <button style="background-color: #555; color: #000;" v-else>Executed on {{ $toDate(proposal.executedOn)
                    }}</button>
                </div>
            </div>
        </div>
        <ProgressPop v-if="progress" />
    </section>
</template>

<script setup>
import IconClock from './icons/IconClock.vue';
import ProgressView from './ProgressView.vue';
import ProgressPop from './ProgressPop.vue';
</script>

<script>
import Factory from '../scripts/Factory';
import DAO from '../scripts/DAO';
import Governance from '../scripts/Governance';
import { messages } from '../reactives/messages'
import IconOut from './icons/IconOut.vue';
export default {
    props: ["userAddress"],
    data() {
        return {
            loading: true,
            address: null,
            dao: null,
            proposal: null,
            proposalId: this.$route.params.pid,
            daoMembers: null,
            allocation: 0,
            progress: false,
            votingPower: 0,
            voters: [],
            voteTypes: [],
            agrees: 0,
            disagrees: 0,
            abstains: 0,
            minVoting: 0
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
        execute: async function () {
            this.progress = true;

            const trx = await Governance.executeProposal(
                this.proposalId,
                `Proposal of ID ${this.proposalId} was executed with funds allocation from treasury`,
                this.address
            )

            if (trx && trx.transactionHash) {
                messages.insertMessage({
                    title: "Proposal has been executed",
                    description: "You have successfully execute this proposal.",
                    type: "success",
                    linkTitle: "View Trx",
                    linkUrl: `https://scan.pego.network/tx/${trx.transactionHash}`
                });
            }
            else {
                messages.insertMessage({
                    title: "Failed to execute proposal",
                    description: "Please try the transaction again",
                    type: "failed"
                });
            }

            this.getProposal();

            this.progress = false;
        },
        vote: async function (voteEntry) {
            this.progress = true;

            const trx = await Governance.voteProposal(this.proposalId, voteEntry, this.$toWei(this.votingPower), this.address);
            if (trx && trx.transactionHash) {
                messages.insertMessage({
                    title: "Your vote has been casted",
                    description: "You have successfully voted to this proposal.",
                    type: "success",
                    linkTitle: "View Trx",
                    linkUrl: `https://scan.pego.network/tx/${trx.transactionHash}`
                });
            }
            else {
                messages.insertMessage({
                    title: "Failed to cast vote",
                    description: "Please try the transaction again",
                    type: "failed"
                });
            }

            this.getProposal();

            this.progress = false;
        },
        hasVoted: function () {
            if (this.userAddress) {
                for (let index = 0; index < this.voters.length; index++) {
                    if (this.voters[index].toLowerCase() == this.userAddress.toLowerCase()) {
                        return true
                    }
                }
                return false
            }
            return false
        },
        getProposal: async function () {
            this.address = await Factory.resolveName(this.$route.params.id);
            this.dao = await DAO.dao(this.address);
            this.proposal = await Governance.getProposal(this.proposalId, this.dao[3]);
            this.loading = false;

            const entries = await Governance.getVoteEntries(this.proposalId, this.dao[3]);
            this.voters = entries[0];
            this.voteTypes = entries[1];
            this.agrees = 0;
            this.disagrees = 0;
            this.abstains = 0;
            for (let index = 0; index < this.voteTypes.length; index++) {
                if (this.voteTypes[index] == 0)
                    this.agrees++;
                if (this.voteTypes[index] == 1)
                    this.disagrees++;
                if (this.voteTypes[index] == 2)
                    this.abstains++;
            }
            this.minVoting = await Governance.minVoting(this.dao[3])
        }
    },
    mounted() {
        this.getProposal();
    },
    components: { IconOut }
}
</script>

<style scoped>
section {
    padding-top: 120px;
    padding-bottom: 100px;
    min-height: 100vh;
}

.grid_container {
    margin-top: 60px;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 30px;
}

.voting {
    padding: 20px;
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    color: var(--black);
    width: 800px;
}

.voting_head h3 {
    font-size: 30px;
    color: #fff;
}

.voting_head {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.voting_body p:first-child {
    font-size: 24px;
    color: #fff;
}

.voting_body p:last-child {
    font-size: 16px;
    color: #999;
}

.voting_head_options {
    display: flex;
    align-items: center;
    background: var(--background);
    border-radius: 12px;
    padding: 6px;
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


.voting_head_options p {
    padding: 10px 20px;
    font-size: 16px;
    font-weight: 600;
    color: #999;
}

.title h3 {
    font-size: 50px;
    font-weight: 600;
    color: #fff;
}

.title .published {
    margin-top: 10px;
    font-size: 14px;
    color: #999;
    font-weight: 500;
}

.title .published a {
    color: var(--primary);
}

.title .summary {
    margin-top: 30px;
    font-size: 20px;
    color: #eee;
}

.created_zone {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.created_zone .links {
    display: flex;
    align-items: center;
    gap: 10px;
}

.created_zone a {
    color: var(--primary);
    font-weight: 500;
    font-size: 16px;
    display: flex;
    align-items: center;
    gap: 4px;
}

.created_zone svg {
    width: 16px;
    height: 16px;
}

.created {
    color: #999;
    display: flex;
    align-items: center;
}

.created_zone span {
    padding: 3px 8px;
    background-color: var(--primary);
    color: #fff;
    font-size: 16px;
    border-radius: 12px;
}

.progress {
    background-color: var(--background);
    border-radius: 12px;
    margin-top: 10px;
}

.progress_bar {
    height: 16px;
    background-color: var(--primary);
    border-radius: 12px;
    transition: .1s;
    width: 0%;
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
    color: #fff;
    margin-left: 4px;
}

.label .desc {
    font-size: 14px;
    font-weight: 500;
    color: #999;
    margin-top: 6px;
}

.label .input {
    /* border: 2px solid rgb(228, 231, 235); */
    background-color: var(--background);
    border-radius: 12px;
    /* background-color: var(--white); */
    overflow: hidden;
    margin-top: 10px;
    display: flex;
    align-items: center;
    cursor: pointer;
}

.yes_head {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.yes_vote {
    margin-top: 40px;
    color: #fff;
}

.yes_head_options {
    display: flex;
    align-items: center;
    gap: 40px;
}

.yes_head_options p {
    min-width: 100px;
    text-align: right;
}

.vote_actions {
    display: grid;
    width: 100%;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    align-items: center;
    gap: 20px;
}

.vote_actions2 {
    display: grid;
    width: 100%;
    grid-template-columns: repeat(1, minmax(0, 1fr));
    align-items: center;
    gap: 20px;
}

.vote_actions button,
.vote_actions2 button {
    background-color: var(--primary);
    color: #fff;
    border-radius: 12px;
    height: 45px;
    padding: 0 16px;
    display: flex;
    align-items: center;
    font-size: 20px;
    justify-content: center;
    border: none;
    font-weight: 500;
    cursor: pointer;
    margin-top: 30px;
}


.token_container {
    padding: 50px;
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    width: 450px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
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
    color: #999;
    margin-top: 10px;
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

.label .input_tag {
    background-color: var(--primary);
    padding: 10px 20px;
    min-width: 100px;
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #000;
    font-weight: 500;
    font-size: 16px;
}

.label input,
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

input::placeholder,
textarea::placeholder {
    color: #eee;
}
</style>