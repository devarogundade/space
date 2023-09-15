<template>
    <section>
        <div class="app-width">
            <div class="explore">
                <div class="search">
                    <h3>Explore DAOs and Communities</h3>
                    <div class="input">
                        <input type="text" v-model="search" placeholder="Search DAOs or Communities">
                    </div>
                    <div class="toolbar">
                        <div class="item" v-on:click="tab = 'all'">
                            <p>All</p>
                            <div class="indicator" v-show="tab == 'all'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'gaming'">
                            <p>Gaming</p>
                            <div class="indicator" v-show="tab == 'gaming'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'defi'">
                            <p>DeFi</p>
                            <div class="indicator" v-show="tab == 'defi'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'infra'">
                            <p>Infra</p>
                            <div class="indicator" v-show="tab == 'infra'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'socialfi'">
                            <p>SocialFi</p>
                            <div class="indicator" v-show="tab == 'socialfi'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'deso'">
                            <p>DeSo</p>
                            <div class="indicator" v-show="tab == 'deso'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'institution'">
                            <p>Institutions</p>
                            <div class="indicator" v-show="tab == 'institution'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'others'">
                            <p>Others</p>
                            <div class="indicator" v-show="tab == 'others'"></div>
                        </div>
                    </div>
                </div>

                <ProgressView v-if="loading" />

                <div class="apps" v-else>
                    <RouterLink v-for="dao, i in filterDao()" :key="i" :to="`/app/daos/${JSON.parse(dao).subdomain}`">
                        <div class="app">
                            <div class="app_head">
                                <img :src="JSON.parse(dao).logo">
                                <div class="app_head_text">
                                    <h6>{{ JSON.parse(dao).name }}</h6>
                                    <p>{{ JSON.parse(dao).subdomain }}.space.pg</p>
                                </div>
                            </div>
                            <p class="app_desc">{{ JSON.parse(dao).summary }}</p>
                            <div class="app_category">
                                <a v-for="link, i in JSON.parse(dao).links" :key="i" target="_blank" :href="link.link">
                                    {{ link.name }}
                                    <IconOut :color="'var(--primary)'" />
                                </a>
                            </div>
                        </div>
                    </RouterLink>
                </div>

                <div class="empty" v-if="!loading && filterDao().length == 0">
                    <img src="/images/empty.png" alt="">
                    <p>No DAOs, Change filter.</p>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import ProgressView from './ProgressView.vue'
import IconOut from './icons/IconOut.vue'
</script>

<script>
import Factory from '../scripts/Factory'
export default {
    data() {
        return {
            tab: 'all',
            daos: [],
            loading: true,
            search: ''
        };
    },
    methods: {
        filterDao: function () {
            if (this.tab != 'all') {
                if (this.search == '') {
                    return this.daos.filter(dao => JSON.parse(dao).category == this.tab)
                } else {
                    return this.daos.filter(dao => JSON.parse(dao).category == this.tab && JSON.parse(dao).name.replaceAll(' ', '').toLowerCase().includes(this.search.replaceAll(' ', '').toLowerCase()))
                }
            } else {
                if (this.search == '') {
                    return this.daos
                } else {
                    return this.daos.filter(dao => JSON.parse(dao).name.replaceAll(' ', '').toLowerCase().includes(this.search.replaceAll(' ', '').toLowerCase()))
                }
            }
        },
        getDaos: async function () {
            this.loading = true;
            this.daos = await Factory.getDoas();
            this.loading = false;
        },
    },
    mounted() {
        this.getDaos();
    }
}
</script>

<style scoped>
section {
    min-height: 100vh;
}

.explore {
    padding-bottom: 50px;
}

.search {
    padding-top: 150px;
    padding-bottom: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
}

.search h3 {
    font-size: 50px;
    text-align: center;
    color: #fff;
    margin-bottom: 40px;
    font-weight: 700;
    text-shadow: 0 0 50px #ac640648, 0 0 26px #ac64066c;
}

.input {
    width: 1000px;
    max-width: 100%;
    height: 60px;
    border: 1px solid #ac64066c;
    border-radius: 12px;
    background-color: rgb(23 25 28 / 1);
}

.input input {
    background: none;
    height: 100%;
    width: 100%;
    font-size: 20px;
    border: none;
    padding: 0 20px;
    font-weight: 600;
    outline: none;
    color: #fff;
}

.input input::placeholder {
    color: #eee;
}


.apps {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 30px;
}

.app {
    padding: 24px;
    border-radius: 12px;
    background-color: rgb(23 25 28 / 1);
    width: 580px;
    border: 1px solid transparent;
    max-width: 100%;
}

.app:hover {
    border: 1px solid var(--primary);
}

.app_head {
    display: grid;
    grid-template-columns: 50px auto;
    gap: 20px;
    align-items: center;
    color: #000;
}

.app_head img {
    width: 50px;
    height: 50px;
    border-radius: 25px;
    object-fit: cover;
}

.app_head h6 {
    font-size: 24px;
    font-weight: 600;
    color: #fff;
}

.app_head p {
    font-size: 14px;
    margin-top: 2px;
    color: #eee;
}

.app_desc {
    color: #999;
    font-size: 16px;
    margin-top: 10px;
    height: 80px;
    color: #999;
}

.app_category {
    display: flex;
    align-items: center;
    margin-top: 20px;
    gap: 10px;
}

.app_category svg {
    width: 14px;
    height: 14px;
}

.app_category a {
    font-size: 14px;
    color: var(--primary);
    display: flex;
    align-items: center;
    gap: 4px;
    font-weight: 500;
}

.toolbar {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px;
    width: 950px;
}

.toolbar .item {
    padding: 0 20px;
    display: flex;
    cursor: pointer;
    user-select: none;
    align-items: center;
    justify-content: center;
    height: 50px;
    font-size: 20px;
    color: #fff;
    position: relative;
}

.item .indicator {
    background: var(--primary);
    height: 6px;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
}
</style>