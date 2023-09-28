<template>
    <NotSupported v-if="notSupported" />
    <section>
        <ProgressView v-if="loading" />
        <div class="app-width" v-else>
            <div class="member_container">
                <div class="members_info">
                    <IconPeople />
                    <RouterLink :to="`/app/daos/${$route.params.id}/incentives/mint`">
                        <button>Mint reward</button>
                    </RouterLink>
                </div>

                <div class="members_count">
                    <h3>{{ rewards [0].length}} Total rewards</h3>
                    <p>Plugin address: {{ plugin }}</p>
                </div>
            </div>

            <div class="dao_form">
                <div class="members form">
                    <div class="member" v-for="reward, i in rewards[0]" :key="i">
                        <div class="member_info">
                            <img src="/images/user.jpg" alt="">
                            <p>{{ reward }}</p>
                        </div>
                        <a :href="`https://scan.pego.network/address/${i}`" target="_blank">
                            <div class="member_link">
                                <p>1 reward</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import ProgressView from './ProgressView.vue';
import NotSupported from './NotSupported.vue';
</script>

<script>
import DAO from '../scripts/DAO';
import Factory from '../scripts/Factory';
import Incentives from '../scripts/Incentives';
export default {
    data() {
        return {
            rewards: [],
            plugin: null,
            loading: true,
            dao: null,
            notSupported: false
        };
    },
    methods: {
        getRewards: async function() {
            this.loading = true
            const address = await Factory.resolveName(this.$route.params.id)
            const dao = await DAO.dao(address)
            this.plugin = await DAO.forcePlugin(address, 1003)
            
            if (this.plugin == '0x0000000000000000000000000000000000000000') {
                this.notSupported = true
                return
            }

            this.rewards = await Incentives.members(this.plugin, dao[4])
            this.loading = false
        }
    },
    mounted() {
        this.getRewards();
    },
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
}

.form {
    width: 700px;
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