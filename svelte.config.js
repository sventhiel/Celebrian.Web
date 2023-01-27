import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/kit/vite';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
	  adapter: adapter({
		// default options are shown
		pages: 'build',
		assets: 'build',
		fallback: null,
	  }),
	//   paths: {
	// 	base: '/JenaExperiment'
	// 	}
	},
  
	preprocess: vitePreprocess()
  };
  
  export default config;