<template>
    <section>
        <div class="app-width">
            <div class="hero">
                <div class="text_content">
                    <h3>
                        Space is a DAO management platform that leverages the capabilities of <span
                            style="color: var(--primary);">PEGO</span> to offer a
                        range of innovative solutions for the expanding Web3 ecosystem.
                    </h3>
                    <p>It is designed to host any arbitrary size of organization, and adaptive by extending the
                        functionality of
                        your DAO with third-parties addon.</p>
                    <RouterLink to="/app/create">
                        <PrimaryButton :text="'Create your DAO'" :width="'220px'" />
                    </RouterLink>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import PrimaryButton from './PrimaryButton.vue';
</script>

<style scoped>
section {
    background-image: url('/images/grainy.png');
    background-repeat: no-repeat;
    background-size: cover;
}

.hero {
    width: 100%;
    min-height: 100vh;
    display: flex;
    justify-content: flex-start;
    align-items: flex-end;
}

.text_content {
    padding: 50px 0;
    width: 750px;
    max-width: 100%;
}

.text_content h3 {
    font-size: 36px;
    color: #fff;
    font-weight: 700;
    line-height: 46px;
}

.text_content p {
    margin-top: 40px;
    font-size: 18px;
    color: #eee;
    margin-bottom: 40px;
}

@media screen and (max-width: 700px) {
    .text_content {
        padding: 20px 0;
    }

    .text_content h3 {
        font-size: 26px;
        color: #fff;
        font-weight: 600;
        line-height: 36px;
    }

    .text_content p {
        margin-top: 30px;
        font-size: 16px;
        color: #eee;
        margin-bottom: 30px;
    }
}
</style>