<script>
    import { onMount } from 'svelte';

    let imagesList;
    let index;

    onMount(async () => {
        const res = await fetch('images.json');
        const data = await res.json();
        imagesList = await data["images"];
	    index = imagesList.length - 1;
    });
</script>


<style>
    img {
        width: 50%;
	}

    #buttons {
        width: 50%;
        display: flex;
    }

    #buttons-left {
        text-align: left;
        flex: 1; /*grow*/
    }

    #buttons-right {
        text-align: right;
        flex: 1; /*grow*/
    }

    #date {
        text-align: center;
        flex: 1; /*grow*/
    }

</style>

{#if imagesList}
<div>
    <img src="images/{imagesList[index]}" alt="" />
</div>


<div id="buttons">
    <div id=buttons-left>
        <button on:click={() => index=0} disabled='{index === 0}'>First</button>
        <button on:click={() => index--} disabled='{index === 0}'>Prev</button>
    </div>

    <div id=date>
        <span>{imagesList[index].split(".")[0]}</span>
    </div>

    <div id=buttons-right>
        <button on:click={() => index++} disabled='{index === imagesList.length -1}'>Next</button>
        <button on:click={() => index=imagesList.length-1} disabled='{index === imagesList.length -1}'>Last</button>
    </div>

</div>
{/if}