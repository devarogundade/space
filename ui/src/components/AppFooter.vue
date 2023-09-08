<template>
    <section>
        <div class="app-width">
            <footer>
                <div class="terms_and_condition">
                    <a href="#" target="_blank">
                        <p>Terms and Condition</p>
                    </a>
                    <a href="#" target="_blank">
                        <p>Privacy Policy</p>
                    </a>
                </div>

                <div class="socials">
                    <a href="#" target="_blank">
                        <IconDiscord />
                    </a>
                    <a href="#" target="_blank">
                        <IconTwitter />
                    </a>
                    <a href="#" target="_blank">
                        <IconTelegram />
                    </a>
                </div>
            </footer>
        </div>
    </section>
</template>

<script setup>
import IconDiscord from './icons/IconDiscord.vue'
import IconTwitter from './icons/IconTwitter.vue'
import IconTelegram from './icons/IconTelegram.vue'
</script>

<style scoped>
section {
    background-color: rgb(23 25 28 / 1);
}

footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
}

.terms_and_condition {
    display: flex;
    align-items: center;
    gap: 20px;
}

.terms_and_condition p {
    color: #fff;
}

.socials {
    display: flex;
    align-items: center;
    gap: 10px;
}

.socials svg {
    background: var(--primary);
    padding: 4px;
    width: 30px;
    height: 30px;
    border-radius: 6px;
}
</style>