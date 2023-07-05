<script>
    import { onMount } from "svelte";

    let imagesList;
    let index;

    onMount(async () => {
        const res = await fetch("images.json");
        const data = await res.json();
        imagesList = await data["images"];
        index = imagesList.length - 1;
    });

    async function fetchImage(index) {
        const response = await fetch(`images/${imagesList[index]}`);

        if (response.ok) {
            return await response.blob();
        }

        throw new Error("Something went wrong.");
    }
</script>

{#if index >= 0}
    <div id="xyz">
        {#await fetchImage(index)}
            <div id="spinner">... loading ...</div>
        {:then data}
            <img src={URL.createObjectURL(data)} alt="" />
        {:catch error}
            <div id="spinner">An error occurred. Could not load image.</div>
        {/await}
    </div>

    <div id="buttons">
        <div id="buttons-left">
            <button on:click={() => (index = 0)} disabled={index === 0}
                >First</button
            >
            <button on:click={() => index--} disabled={index === 0}>Prev</button
            >
        </div>

        <div id="date">
            <span>{imagesList[index].split(".")[0]}</span>
        </div>

        <div id="buttons-right">
            <button
                on:click={() => index++}
                disabled={index === imagesList.length - 1}>Next</button
            >
            <button
                on:click={() => (index = imagesList.length - 1)}
                disabled={index === imagesList.length - 1}>Last</button
            >
        </div>
    </div>
{:else}
    ...loading...
{/if}

<style>
    img {
        width: 100%;
    }

    #xyz {
        display: contents;
    }

    #spinner {
        text-align: center;
    }

    #buttons {
        width: 100%;
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
