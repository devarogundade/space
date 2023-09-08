<template>
    <section>
        <div class="app-width">
            <header>
                <RouterLink to="/app/explore">
                    <img src="/images/logo.png" alt="" />
                </RouterLink>
                <div class="links">
                    <RouterLink to="/">Homepage</RouterLink>
                    <a href="">Docs</a>
                    <RouterLink to="/app/plugins">Plugins Marketplace</RouterLink>
                    <RouterLink to="/app/create">Create new DAO</RouterLink>
                    <PrimaryButton v-if="userAddress" v-on:click="connectWallet()" :text="userAddress.substring(0, 4) + '•••' +
                        userAddress.substring(userAddress.length - 4,
                            userAddress.length)" :width="'200px'" />
                    <PrimaryButton v-else v-on:click="connectWallet()" :text="'Connect Wallet'" :width="'200px'" />
                </div>
            </header>
        </div>
    </section>
</template>

<script setup>
import PrimaryButton from './PrimaryButton.vue';
</script>

<script>
import Authentication from '../scripts/Authentication';

export default {
    props: ["userAddress"],
    methods: {
        connectWallet: async function () {
            Authentication.openModal()
            this.getAddress()
        },
        getAddress: async function () {
            await Authentication.userAddress((address) => {
                this.$emit('connected', address)
            })
        }
    },
    mounted() {
        this.getAddress()
    },
}
</script>

<style scoped>
section {
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    z-index: 10;
    backdrop-filter: blur(12px);
}

header {
    height: 100px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

header img {
    height: 50px;
}

.links {
    display: flex;
    align-items: center;
    gap: 40px;
}

.links a {
    color: #fff;
    font-size: 20px;
    font-weight: 600;
}
</style>