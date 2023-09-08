<template>
    <section>
        <ProgressView v-if="progress" />
        <div class="app-width" v-else>
            <div class="explore">
                <div class="search">
                    <h3>Plugins Marketplace</h3>
                    <div class="input">
                        <input v-model="search" type="text" placeholder="Search Plugins">
                    </div>
                    <div class="toolbar">
                        <div class="item" v-on:click="tab = 'all'">
                            <p>All</p>
                            <div class="indicator" v-show="tab == 'all'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'oracle'">
                            <p>Oracle</p>
                            <div class="indicator" v-show="tab == 'oracle'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'membership'">
                            <p>Membership</p>
                            <div class="indicator" v-show="tab == 'membership'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'incentives'">
                            <p>Incentives</p>
                            <div class="indicator" v-show="tab == 'incentives'"></div>
                        </div>

                        <div class="item" v-on:click="tab = 'external'">
                            <p>External contracts</p>
                            <div class="indicator" v-show="tab == 'external'"></div>
                        </div>
                    </div>
                </div>

                <div class="apps">
                    <div class="app" v-for="plugin, i in filterPlugins()" :key="i">
                        <div class="app_head">
                            <IconBoxTick :color="'var(--primary)'" />
                            <div class="app_head_text">
                                <h6>{{ plugin.name }}</h6>
                                <p>{{ plugin.category }}</p>
                            </div>
                        </div>
                        <p class="app_desc">{{ plugin.summary }}</p>
                        <div class="app_category">
                            <a v-for="link, i in plugin.links" :key="i" target="_blank" :href="link.link">
                                {{ link.name }}
                                <IconOut v-if="link.link != ''" :color="'var(--primary)'" />
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import IconBoxTick from './icons/IconBoxTick.vue';
import IconOut from './icons/IconOut.vue'
import ProgressView from './ProgressView.vue';
</script >

<script>
export default {
    data() {
        return {
            tab: "all",
            search: "",
            plugins: [
                {
                    name: "Voting token plugin",
                    logo: "/images/logo.png",
                    category: "membership",
                    summary: "Tokens act as voting chips. The more tokens you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Github",
                            link: ""
                        }
                    ]
                },
                {
                    name: "Voting NFT plugin",
                    logo: "/images/logo.png",
                    category: "membership",
                    summary: "NFTs act as voting chips. The more NFTs you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Github",
                            link: ""
                        }
                    ]
                },
                {
                    name: "NFT Reward plugin",
                    logo: "/images/logo.png",
                    category: "incentives",
                    summary: "Tokens act as voting chips. The more tokens you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Github",
                            link: ""
                        }
                    ]
                },
                {
                    name: "Multi-Sig plugin",
                    logo: "/images/logo.png",
                    category: "membership",
                    summary: "Tokens act as voting chips. The more tokens you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Github",
                            link: ""
                        }
                    ]
                },
                {
                    name: "Price feed plugin",
                    logo: "/images/logo.png",
                    category: "oracle",
                    summary: "Tokens act as voting chips. The more tokens you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Coming soon",
                            link: ""
                        }
                    ]
                },
                {
                    name: "W3Swap",
                    logo: "/images/logo.png",
                    category: "external",
                    summary: "Tokens act as voting chips. The more tokens you hold, the more weight your vote has. 1 token equals 1 vote",
                    links: [
                        {
                            name: "Coming soon",
                            link: ""
                        }
                    ]
                }
            ],
            progress: true
        };
    },
    methods: {
        filterPlugins: function () {
            if (this.tab != "all") {
                if (this.search == "") {
                    return this.plugins.filter(plugin => plugin.category == this.tab);
                }
                else {
                    return this.plugins.filter(plugin => plugin.name == this.tab && plugin.name.replaceAll(" ", "").toLowerCase().includes(this.search.replaceAll(" ", "").toLowerCase()));
                }
            }
            else {
                if (this.search == "") {
                    return this.plugins;
                }
                else {
                    return this.plugins.filter(plugin => plugin.name.replaceAll(" ", "").toLowerCase().includes(this.search.replaceAll(" ", "").toLowerCase()));
                }
            }
        }
    },
    mounted() {
        const context = this;
        setTimeout(() => {
            context.progress = false;
        }, 1000);
    },
    components: { IconBoxTick }
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
    text-shadow: 0 0 50px #ed4f3348, 0 0 26px #ed4f336c;
}

.input {
    width: 1000px;
    max-width: 100%;
    height: 60px;
    border: 1px solid #ed4f336c;
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
    gap: 30px;
}

.app {
    padding: 24px;
    border-radius: 12px;
    background-color: rgb(23 25 28 / 1);
    width: 428px;
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
    color: var(--black);
}

.app_head svg {
    width: 50px;
    height: 50px;
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
    color: var(--gray-dark);
    font-size: 16px;
    margin-top: 10px;
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