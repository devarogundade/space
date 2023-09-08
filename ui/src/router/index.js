import { createRouter, createWebHistory } from 'vue-router'
import AppView from '../views/AppView.vue'
import HomeView from '../views/HomeView.vue'
import DAOView from '../views/DAOView.vue'

import HomePage from '../components/HomePage.vue'
import ExplorePage from '../components/ExplorePage.vue'
import CreatePage from '../components/CreatePage.vue'
import DAOPage from '../components/DAOPage.vue'
import ProposalPage from '../components/ProposalPage.vue'
import DAOMembers from '../components/DAOMembers.vue'
import MintMember from '../components/MintMember.vue'
import DAOTreasury from '../components/DAOTreasury.vue'
import CreateProposal from '../components/CreateProposal.vue'
import PluginsMarketplace from '../components/PluginsMarketplace.vue'
import DAOSettings from '../components/DAOSettings.vue'
import DAOIncentives from '../components/DAOIncentives.vue'
import FundTreasury from '../components/FundTreasury.vue'
import DAOGovernance from '../components/DAOGovernance.vue'
import MintIncentive from '../components/MintIncentive.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  },
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      children: [
        {
          path: '/',
          name: 'home',
          component: HomePage
        }
      ]
    },
    {
      path: '/',
      name: 'app',
      component: AppView,
      children: [
        {
          path: '/app/explore',
          name: 'app-explore',
          component: ExplorePage
        },   {
          path: '/app/plugins',
          name: 'app-plugins',
          component: PluginsMarketplace
        },
        {
          path: '/app/create',
          name: 'app-create',
          component: CreatePage
        }
      ]
    },
    {
      path: '/',
      name: 'dao',
      component: DAOView,
      children: [
        {
          path: '/app/daos/:id',
          name: 'app-daos-dao',
          component: DAOPage
        },
        {
          path: '/app/daos/:id/proposals/create',
          name: 'app-daos-dao-governance-proposal-create',
          component: CreateProposal
        },
        {
          path: '/app/daos/:id/proposals/:pid',
          name: 'app-daos-dao-governance-proposal',
          component: ProposalPage
        },
        {
          path: '/app/daos/:id/members',
          name: 'app-daos-dao-members',
          component: DAOMembers
        },
        {
          path: '/app/daos/:id/members/mint',
          name: 'app-daos-dao-members-mint',
          component: MintMember
        },
        {
          path: '/app/daos/:id/incentives/mint',
          name: 'app-daos-dao-incentives-mint',
          component: MintIncentive
        },
        {
          path: '/app/daos/:id/treasury',
          name: 'app-daos-dao-treasury',
          component: DAOTreasury
        },{
          path: '/app/daos/:id/governance',
          name: 'app-daos-dao-governance',
          component: DAOGovernance
        },
        {
          path: '/app/daos/:id/settings',
          name: 'app-daos-dao-settings',
          component: DAOSettings
        },
        {
          path: '/app/daos/:id/incentives',
          name: 'app-daos-dao-incentives',
          component: DAOIncentives
        },
        {
          path: '/app/daos/:id/treasury/fund',
          name: 'app-daos-dao-treasury-fund',
          component: FundTreasury
        }
      ]
    },
  ]
})

export default router
