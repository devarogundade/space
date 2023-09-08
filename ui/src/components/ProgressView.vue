<template>
    <div class="container">
        <ProgressBox />
    </div>
</template>

<script setup>
import ProgressBox from './ProgressBox.vue';
</script>

<style scoped>
.container {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
</style>