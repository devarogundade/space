<template>
    <AppHeader :userAddress="userAddress" v-on:connected="userAddress = $event" />
    <RouterView :userAddress="userAddress" />
    <AppFooter />
</template>

<script setup>
import AppHeader from '../components/AppHeader.vue';
import AppFooter from '../components/AppFooter.vue';
</script>

<script>
export default {
    data() {
        return {
            userAddress: null
        };
    },
}
</script>