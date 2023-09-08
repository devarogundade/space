<template>
  <RouterView />
  <SnackBar />
</template>

<script setup>
import SnackBar from './components/SnackBar.vue';
</script>

<script>
import Authentication from './scripts/Authentication';

export default {
  created() {
    Authentication.initialize()
  }
}
</script>

