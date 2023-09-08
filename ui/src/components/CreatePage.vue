<template>
    <section>
        <div class="app-width">
            <div class="create_head">
                <div class="create_head_title">
                    <p>Create your DAO</p>
                    <p>Step {{ step }} of 4</p>
                </div>

                <div class="progress">
                    <div class="progress_bar" :style="`width: ${(step / 4) * 100}%`"></div>
                </div>

                <div class="create_head_desc" v-if="step == 1">
                    <h1>Describe your DAO</h1>
                    <p>Name and define your DAO so new contributors know they've come to the right place. This information
                        is displayed on the DAO Explore page and can be changed with a vote. For ideas on DAO branding, read
                        our guide.</p>
                </div>

                <div class="create_head_desc" v-if="step == 2">
                    <h1>Define membership</h1>
                    <p>Decide the type of voting your DAO uses. You can change these settings with a vote. For help deciding
                        which type of governance is best for you, read this guide.</p>
                </div>

                <div class="create_head_desc" v-if="step == 3">
                    <h1>Select governance settings</h1>
                    <p>These settings determine how voting works in your DAO. Read best practices for governance settings in
                        this guide.</p>
                </div>

                <div class="create_head_desc" v-if="step == 4">
                    <h1>Set governance reward</h1>
                    <p>Define how your want to reward your DAO member for participating in improvement proposal creation and
                        voting with vote receipt NFT staking.</p>
                </div>
            </div>

            <div class="dao_form">
                <div class="form">
                    <div class="label" v-show="step == 1">
                        <p class="title">DAO name</p>
                        <p class="desc">Maximum of 128 characters</p>
                        <div class="input">
                            <input v-model="dao.name" type="text" placeholder="Type your DAO's name...">
                        </div>
                        <p class="count">{{ dao.name.length }}/128</p>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">PEGO Subdomain</p>
                        <p class="desc">This will be your DAO’s AENS unique subdomain, created automatically for you.
                            Lowercase letters, numbers, and the dash '-' are all acceptable characters; ideally, the
                            character count should be under 64.</p>
                        <div class="input">
                            <input v-model="dao.subdomain" type="text" placeholder="Type your DAO's name...">
                            <div class="input_tag">.space.pg</div>
                        </div>
                        <p class="count">{{ dao.subdomain.length }}/64</p>
                        <p style="color: green;" v-if="dao.subdomain != '' && isNameAvailable">Name is available</p>
                        <p style="color: red;" v-else-if="dao.subdomain != '' && !isNameAvailable">Name is not available</p>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Logo <span>Optional</span></p>
                        <p class="desc">This will be your DAO’s logoURI image</p>

                        <div class="input_file">
                            <IconImageAdd :color="'#fff'" />
                            <input v-on:change="pickLogo($event)" type="file" accept="image/*">
                        </div>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Description</p>
                        <p class="desc">Describe your DAO's purpose in a few sentences. This is listed on the Explore page
                            so new contributors can find you.
                        </p>
                        <div class="input">
                            <textarea v-model="dao.summary" rows="5" type="text"
                                placeholder="Type your summary..."></textarea>
                        </div>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Links <span>Optional</span></p>
                        <p class="desc">Links to your DAO's website, social media profiles, Discord, or other places your
                            community gathers.</p>
                        <div class="link_container" v-if="dao.links.length > 0">
                            <div class="link_grid">
                                <p class="link_name">Name / Description</p>
                                <p class="link_name">Link</p>
                                <p></p>
                            </div>
                            <div class="link_grid" v-for="link, i in dao.links" :key="i">
                                <div class="input">
                                    <input type="text" v-model="link.name" placeholder="Medium, Discord, etc.">
                                </div>
                                <div class="input">
                                    <input type="text" v-model="link.link" placeholder="https://">
                                </div>
                                <IconTrash v-on:click="removeLink(i)" />
                            </div>
                        </div>
                        <button v-if="dao.links.length < 5" v-on:click="addLink()">Add link</button>
                    </div>

                    <div class="label" v-show="step == 1">
                        <p class="title">Category</p>
                        <p class="desc">Choose a category that best fits your DAO.
                        </p>
                        <select name="categories" v-on:change="pickCategory">
                            <option value="defi">DeFi</option>
                            <option value="gaming">Gaming</option>
                            <option value="infra">Infra</option>
                            <option value="socialfi">SocialFi</option>
                            <option value="deso">DeSo</option>
                            <option value="institution">Institution</option>
                            <option value="others">Others</option>
                        </select>
                    </div>

                    <!--  -->

                    <div class="label" v-show="step == 2">
                        <p class="title">Who can participate in governance?</p>
                        <div class="participate_options">
                            <div v-on:click="dao.membership = 0"
                                :class="dao.membership == 0 ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>Voting token plugin</h6>
                                    <p>Tokens act as voting chips. The more tokens you hold, the more weight your vote has.
                                        1 token equals 1 vote.</p>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>

                            <div v-on:click="dao.membership = 1"
                                :class="dao.membership == 1 ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>Non fungible token plugin</h6>
                                    <p>NFTs act as voting chips. The more tokens you hold, the more weight your vote has.
                                        1 token equals 1 vote.</p>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>

                            <div v-on:click="dao.membership = 2"
                                :class="dao.membership == 2 ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>Multisig plugin</h6>
                                    <p>Only multisig members can vote. 1 wallet address equals 1 approval.</p>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 2 && (dao.membership == 0 || dao.membership == 1)">
                        <p class="title" v-show="dao.membership == 0">Mint your token</p>
                        <p class="title" v-show="dao.membership == 1">Mint your NFT</p>
                        <p class="desc">Define the token details and distribute tokens to a core team and DAO treasury</p>
                    </div>

                    <div class="label" v-show="step == 2 && (dao.membership == 0 || dao.membership == 1)">
                        <p class="title">Name</p>
                        <p class="desc">The full name of the token. Example: My Token</p>
                        <div class="input">
                            <input v-model="dao.tokenName" type="text" placeholder="">
                        </div>
                    </div>

                    <div class="label" v-show="step == 2 && (dao.membership == 0 || dao.membership == 1)">
                        <p class="title">Symbol</p>
                        <p class="desc">The abbreviation of the token. Example: MYT</p>
                        <div class="input">
                            <input v-model="dao.tokenSymbol" type="text" placeholder="">
                        </div>
                    </div>

                    <div class="label" v-if="step == 2 && dao.membership == 1">
                        <p class="title">NFT Image</p>
                        <div class="input_file nft_input_file">
                            <IconImageAdd :color="'#fff'" />
                            <input v-on:change="pickTokenNFT($event)" type="file" accept="image/*">
                        </div>
                    </div>

                    <div class="label" v-show="step == 2 && (dao.membership == 0 || dao.membership == 1)">
                        <p class="title">Distribute tokens</p>
                        <p class="desc">Add the wallets you'd like to distribute tokens to. If you need help distributing
                            tokens</p>
                        <div class="address_container" v-if="dao.tokenAllocations.length > 0">
                            <div class="address_grid">
                                <p class="address_name">Address</p>
                                <p class="address_name">Tokens</p>
                                <p class="address_name">Allocation</p>
                                <p></p>
                            </div>
                            <div class="address_grid" v-for="allocation, i in dao.tokenAllocations" :key="i">
                                <div class="input">
                                    <input type="text" v-model="allocation.address" placeholder="0x...">
                                </div>
                                <div class="input">
                                    <input type="number" v-model="allocation.tokens" min="0" placeholder="0"
                                        style="text-align: center;">
                                </div>
                                <div class="input">
                                    <input type="text" disabled :value="((allocation.tokens / totalSupply) * 100) + '%'"
                                        style="background-color: var(--background-gray); text-align: center;">
                                </div>
                                <IconTrash v-on:click="removeAllocation(i)" />
                            </div>
                            <br> <br>
                            <div class="address_grid">
                                <p class="address_name">{{ dao.tokenAllocations.length }} Addresses</p>
                                <p class="address_name">Initial Supply: {{ totalSupply }}</p>
                                <p class="address_name"></p>
                                <p></p>
                            </div>
                        </div>
                        <button v-if="dao.tokenAllocations.length < 15" v-on:click="addAllocation()">Add wallet</button>
                    </div>

                    <div class="label" v-show="step == 2 && dao.membership == 2">
                        <p class="title">Distribute tokens</p>
                        <p class="desc">Add the wallets you'd like to distribute tokens to. If you need help distributing
                            tokens</p>
                        <div class="address_container" v-if="dao.multisigMembers.length > 0">
                            <div class="address_grid">
                                <p class="address_name">Address</p>
                                <p class="address_name">Allocation</p>
                                <p></p>
                            </div>
                            <div class="address_grid" v-for="member, i in dao.multisigMembers" :key="i">
                                <div class="input">
                                    <input type="text" v-model="member.address" placeholder="0x...">
                                </div>
                                <div class="input">
                                    <input type="text" disabled :value="((member.powers / totalPower) * 100) + '%'"
                                        style="background-color: var(--background-gray); text-align: center;">
                                </div>
                                <IconTrash v-on:click="removeMember(i)" />
                            </div>
                            <br> <br>
                            <div class="address_grid">
                                <p class="address_name">{{ dao.multisigMembers.length }} Addresses</p>
                                <p class="address_name">Total Power: {{ totalPower }}</p>
                                <p class="address_name"></p>
                                <p></p>
                            </div>
                        </div>
                        <button v-if="dao.tokenAllocations.length < 25" v-on:click="addMember()">Add member</button>
                    </div>

                    <div class="label" v-show="step == 2">
                        <p class="title">Proposal creation</p>
                        <p class="desc">Specify who is permitted to create proposals and what the minimum {{
                            dao.membership == 0 ? 'token' : 'power' }} requirement
                            is.</p>
                        <div class="specify_container">
                            <div class="participate_options">
                                <p class="title">Who is eligible?</p>
                                <div v-on:click="dao.proposalCreation = 0"
                                    :class="dao.proposalCreation == 0 ? 'option option_active' : 'option'">
                                    <div class="option_text">
                                        <h6 v-if="dao.membership == 0">Token holders</h6>
                                        <h6 v-if="dao.membership == 1">Multisig members</h6>
                                        <p>Only {{ dao.membership == 0 ? 'token holders' : 'multisig members' }} with a
                                            certain number of
                                            {{ dao.membership == 0 ? 'tokens' : 'powers' }} are eligible to create
                                            proposals.</p>
                                    </div>
                                    <div class="option_dot">
                                        <div class="inner_dot"></div>
                                    </div>
                                </div>

                                <div v-on:click="dao.proposalCreation = 1"
                                    :class="dao.proposalCreation == 1 ? 'option option_active' : 'option'">
                                    <div class="option_text">
                                        <h6>Any wallet</h6>
                                        <p>Any wallet can create proposals.</p>
                                    </div>
                                    <div class="option_dot">
                                        <div class="inner_dot"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="tokens_required" :style="dao.proposalCreation == 1 ? 'opacity: 0.5' : ''">
                                <p class="title">Minimum {{ dao.membership == 0 ? 'tokens' : 'powers' }} Required</p>
                                <div class="input">
                                    <input :disabled="dao.proposalCreation == 1" v-model="dao.minPropose" type="number"
                                        min="1" placeholder="0" style="text-align: center;">
                                    <div class="input_tag">{{ dao.tokenSymbol != '' ? '$' + dao.tokenSymbol : '$Token' }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--  -->

                    <div class="label" v-show="step == 3">
                        <p class="title">Support threshold</p>
                        <p class="desc">Support threshold is the percentage of tokens or that are required to vote “Yes” for
                            a proposal to be approved, calculated based on total tokens that voted.</p>
                        <div class="input">
                            <input v-model="dao.threshold" type="number" placeholder="50">
                            <div class="input_tag">%</div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 3">
                        <p class="title">Minimum voting</p>
                        <p class="desc">Minimum voting is the percentage of the token supply that must vote on a
                            proposal for the vote to be valid. Make sure you set this at a low level that your DAO can meet,
                            so you don't lock your voting process.</p>
                        <div class="input">
                            <input v-model="dao.minVoting" type="number" placeholder="50">
                            <div class="input_tag">{{ dao.tokenSymbol != '' ? '$' + dao.tokenSymbol : '$Token' }}</div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 3">
                        <p class="title">Minimum duration</p>
                        <p class="desc">Minimum duration is the shortest length of time a proposal can be open for voting.
                            You can extend the duration for each proposal but not shorten it.</p>
                        <div class="input">
                            <input v-model="dao.minDuration" type="number" placeholder="30">
                            <div class="input_tag">days</div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 3">
                        <p class="title">Early execution</p>
                        <p class="desc">Allow proposal execution before the vote ends if the requirements are met and the
                            vote outcome cannot be changed by more voters participating.</p>
                        <div class="participate_options">
                            <div v-on:click="dao.earlyExecution = true"
                                :class="dao.earlyExecution ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>Yes</h6>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>

                            <div v-on:click="dao.earlyExecution = false"
                                :class="!dao.earlyExecution ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>No</h6>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 3">
                        <p class="title">Parent DAO subdomain</p>
                        <p class="desc">Attach this DAO to an existing dao as a child DAO.</p>
                        <div class="input">
                            <input v-model="dao.parentSubdomain" type="text" placeholder="parent">
                            <div class="input_tag">.space.pg</div>
                        </div>
                    </div>

                    <!--  -->

                    <div class="label" v-show="step == 4">
                        <p class="title">Reward type</p>
                        <p class="desc">Reward your DAO community and participants with non fungible tokens (NFTs).</p>
                        <div class="participate_options">
                            <div v-on:click="dao.incentives = 1"
                                :class="dao.incentives == 1 ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>NFT Reward</h6>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>

                            <div v-on:click="dao.incentives = 0"
                                :class="dao.incentives == 0 ? 'option option_active' : 'option'">
                                <div class="option_text">
                                    <h6>None</h6>
                                </div>
                                <div class="option_dot">
                                    <div class="inner_dot"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="label" v-show="step == 4 && dao.incentives == 1">
                        <p class="title">NFT Image</p>
                        <p class="desc">This will be your DAO’s NFT reward image</p>

                        <div class="input_file nft_input_file">
                            <IconImageAdd />
                            <input v-on:change="pickRewardNFT($event)" type="file" accept="image/*">
                        </div>
                    </div>

                    <!--  -->

                    <div class="navigation">
                        <RouterLink to="/app/explore" v-if="step == 1">
                            <button v-on:click="prevStep()">
                                <IconArrowLeft :color="'#fff'" /> Cancel
                            </button>
                        </RouterLink>
                        <button v-on:click="prevStep()" v-else>
                            <IconArrowLeft :color="'#fff'" /> Prev
                        </button>

                        <button v-on:click="deploy()" v-if="step == 4">Deploy your DAO
                            <IconArrowRight :color="'#fff'" />
                        </button>
                        <button v-on:click="nextStep()" v-else>Next
                            <IconArrowRight :color="'#fff'" />
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <ProgressPop v-if="progress" />
    </section>
</template>

<script setup>
import IconTrash from './icons/IconTrash.vue'
import IconImageAdd from './icons/IconImageAdd.vue'
import IconArrowLeft from './icons/IconArrowLeft.vue'
import IconArrowRight from './icons/IconArrowRight.vue'
import ProgressPop from './ProgressPop.vue'
</script>

<script>
import { messages } from '../reactives/messages'
import StorageAPI from '../scripts/StorageAPI'
import Factory from '../scripts/Factory'
export default {
    data() {
        return {
            dao: {
                name: '',
                summary: '',
                logoURI: '',
                subdomain: '',
                category: 'defi',
                links: [
                    {
                        name: '',
                        link: ''
                    }
                ],
                membership: 0,
                tokenName: '',
                tokenSymbol: '',
                tokenAllocations: [
                    {
                        address: '',
                        tokens: 10000000
                    }
                ],
                multisigMembers: [
                    {
                        address: '',
                        powers: 1
                    }
                ],
                proposalCreation: 0,
                minPropose: 10,
                threshold: 50,
                minVoting: 1,
                minDuration: 30,
                earlyExecution: true,
                incentives: 1,
                parentSubdomain: '',
                tokenURI: '',
                rewardURI: ''
            },
            totalSupply: 10,
            totalPower: 10,
            step: 1,
            progress: false,
            logoFile: null,
            tokenFile: null,
            rewardFile: null,
            isNameAvailable: true
        }
    },
    watch: {
        dao: {
            handler: function (newDao) {
                this.totalSupply = 0
                this.totalPower = 0
                for (let index = 0; index < newDao.tokenAllocations.length; index++) {
                    const allocation = newDao.tokenAllocations[index];
                    this.totalSupply += allocation.tokens
                }
                for (let index = 0; index < newDao.multisigMembers.length; index++) {
                    const member = newDao.multisigMembers[index];
                    this.totalPower += member.powers
                }
                this.checkIsNameAvailable(this.dao.subdomain)
            },
            deep: true
        }
    },
    methods: {
        pickCategory: function (e) {
            this.dao.category = e.target.value
        },
        checkIsNameAvailable: async function (subdomain) {
            this.isNameAvailable = await Factory.availability(subdomain)
        },
        pickLogo: function (e) {
            const files = e.target.files
            if (files.length > 0) {
                this.logoFile = files[0]
            } else {
                this.logoFile = null
            }
        },
        pickTokenNFT: function (e) {
            const files = e.target.files
            if (files.length > 0) {
                this.tokenFile = files[0]
            } else {
                this.tokenFile = null
            }
        },
        pickRewardNFT: function (e) {
            const files = e.target.files
            if (files.length > 0) {
                this.rewardFile = files[0]
            } else {
                this.rewardFile = null
            }
        },
        deploy: async function () {
            if (this.dao.name == '') {
                alert('Enter DAO name')
                return
            }
            if (this.dao.subdomain == '') {
                alert('Enter DAO subdomain')
                return
            }
            if (this.dao.summary == '') {
                alert('Enter DAO summary')
                return
            }
            for (let index = 0; index < this.dao.links.length; index++) {
                const link = this.dao.links[index];
                if (link.name == '' || !link.link.startsWith('http')) {
                    alert('Enter a valid link name and url')
                    return
                }
            }
            if ((this.dao.membership == 0 || this.dao.membership == 1) && this.dao.tokenName == '') {
                alert('Enter DAO token name')
                return
            }
            if ((this.dao.membership == 0 || this.dao.membership == 1) && this.dao.tokenSymbol == '') {
                alert('Enter DAO token symbol')
                return
            }
            if (this.dao.membership == 0 || this.dao.membership == 1) {
                for (let index = 0; index < this.dao.tokenAllocations.length; index++) {
                    const address = this.dao.tokenAllocations[index];
                    if (address.address == '' || address.tokens == '') {
                        alert(`Enter a valid member address and tokens at ${index + 1}`)
                        return
                    }
                }
            } else {
                for (let index = 0; index < this.dao.multisigMembers.length; index++) {
                    const address = this.dao.multisigMembers[index];
                    if (address.address == '' || address.powers == '') {
                        alert(`Enter a valid member address and powers at ${index + 1}`)
                        return
                    }
                }
            }
            if (this.dao.proposalCreation == 0 && this.dao.minPropose == '') {
                alert('Enter DAO minimum token for creation')
                return
            }
            if (this.dao.threshold == '') {
                alert('Enter DAO threshold')
                return
            }
            if (this.dao.minVoting == '') {
                alert('Enter DAO minimum token for voting')
                return
            }
            if (this.dao.minDuration == '') {
                alert('Enter DAO minimum duration for proposals')
                return
            }

            if (confirm('Confirm to deploy DAO')) {
                this.progress = true

                if (this.logoFile) {
                    const imageUrl = await StorageAPI.upload(this.logoFile, `logos/${this.dao.subdomain}`)
                    if (imageUrl) this.dao.logoURI = imageUrl
                }

                if (this.tokenFile) {
                    const tokenUrl = await StorageAPI.upload(this.tokenFile, `tokens/${this.dao.subdomain}`)
                    if (tokenUrl) this.dao.tokenURI = tokenUrl
                }

                if (this.rewardFile) {
                    const rewardUrl = await StorageAPI.upload(this.rewardFile, `rewards/${this.dao.subdomain}`)
                    if (rewardUrl) this.dao.rewardURI = rewardUrl
                }

                const metadata = {
                    name: this.dao.name,
                    summary: this.dao.summary,
                    logo: this.dao.logoURI,
                    links: this.dao.links,
                    subdomain: this.dao.subdomain.toLocaleLowerCase(),
                    category: this.dao.category
                }

                const holders = []
                const allocations = []

                if (this.dao.membership == 0 || this.dao.membership == 1) {
                    for (let index = 0; index < this.dao.tokenAllocations.length; index++) {
                        holders.push(this.dao.tokenAllocations[index].address)
                        if (this.dao.membership == 0) {
                            allocations.push(this.$toWei(this.dao.tokenAllocations[index].tokens))
                        } else {
                            allocations.push(this.dao.tokenAllocations[index].tokens)
                        }
                    }
                } else {
                    for (let index = 0; index < this.dao.multisigMembers.length; index++) {
                        holders.push(this.dao.multisigMembers[index].address)
                        allocations.push(this.dao.multisigMembers[index].powers)
                    }
                }

                this.dao.parentSubdomain = await Factory.resolveName(this.dao.parentSubdomain)

                const trx = await Factory.deploy(
                    JSON.stringify(metadata),
                    holders,
                    allocations,
                    this.dao
                )

                if (trx && trx.transactionHash) {
                    messages.insertMessage({
                        title: "Your DAO has been deployed on PEGO",
                        description: "You have successfully created a new DAO.",
                        type: "success",
                        linkTitle: "View Trx",
                        linkUrl: `https://testnet.escan.live/tx/${trx.transactionHash}`
                    });
                }
                else {
                    messages.insertMessage({
                        title: "Failed to deploy DAO",
                        description: "Please try the transaction again",
                        type: "failed"
                    });
                }
            }
            
            this.progress = false
        },
        prevStep: function () {
            if (this.step > 1) {
                this.step--
            }
        },
        nextStep: function () {
            if (this.step < 4) {
                this.step++
            }
        },
        addLink: function () {
            this.dao.links.push({ name: '', link: '' })
        },
        removeLink: function (index) {
            this.dao.links.splice(index, 1)
        },
        addAllocation: function () {
            this.dao.tokenAllocations.push({ address: '', tokens: 100 })
        },
        addMember: function () {
            this.dao.multisigMembers.push({ address: '', powers: 1 })
        },
        removeAllocation: function (index) {
            this.dao.tokenAllocations.splice(index, 1)
        },
        removeMember: function (index) {
            this.dao.multisigMembers.splice(index, 1)
        }
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
    border-radius: 12px;
    /* border: rgb(228, 231, 235) 1px solid; */
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
    color: #eee;
}

.create_head_title p:last-child {
    color: #fff;
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
    /* border: 2px solid rgb(228, 231, 235); */
    background-color: rgb(23 25 28 / 1);
    border-radius: 12px;
    /* background-color: var(--white); */
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
    cursor: pointer;
}

input::placeholder,
textarea::placeholder {
    color: #eee;
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
    border: 2px solid rgb(23 25 28 / 1);
    padding: 16px 20px;
    border-radius: 12px;
    display: grid;
    grid-template-columns: auto 20px;
    gap: 10px;
    cursor: pointer;
    user-select: none;
}

.participate_options .option_active {
    border: 2px solid var(--primary) !important;
}

.option h6 {
    font-size: 16px;
    font-weight: 600;
    color: #fff;
}


.option p {
    font-size: 12px;
    font-weight: 500;
    margin-top: 6px;
    color: #999;
}

.option_dot {
    width: 20px;
    height: 20px;
    border: 2px solid rgb(23 25 28 / 1);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.participate_options .option_active .option_dot {
    border: 2px solid var(--primary);
}


.participate_options .option_active .inner_dot {
    background-color: rgb(23 25 28 / 1);
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