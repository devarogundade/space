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
    height: 120px;
    width: 120px;
    display: flex;
    align-items: center;
    justify-content: center;
    transform: translate(-50%, -50%);
    background: #fff;
    border-radius: 12px;
    z-index: 2;
}
</style>