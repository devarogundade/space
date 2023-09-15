<template>
    <section>
        <div class="app-width">
            <header>
                <RouterLink to="/">
                    <SpaceLogo />
                </RouterLink>
                <div class="links">
                    <a href="">Docs</a>
                    <RouterLink to="/app/plugins">Plugins Marketplace</RouterLink>
                    <a target="_blank" href="https://github.com/devarogundade/space">Github</a>
                    <RouterLink to="/app/explore">
                        <PrimaryButton :text="'Explore DAOs'" :width="'200px'" />
                    </RouterLink>
                </div>
            </header>
        </div>
    </section>
</template>

<script setup>
import PrimaryButton from './PrimaryButton.vue';
import SpaceLogo from './icons/SpaceLogo.vue';
</script>

<style scoped>
section {
    position: fixed;
    left: 0;
    top: 0;
    z-index: 10;
    width: 100%;
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

@media screen and (max-width: 700px) {
    .links a {
        display: none;
    }

    .links a:last-child {
        display: block;
    }
}
</style>