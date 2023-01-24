<template>
    <div>
        <div class="ReportBody">
            <p class="ExitButton" v-on:click="close()">X</p>
            <div class="Element">
                <div class="ElementTitleBox">
                    <img src="img/simbol.png" class="ElementTitleImage" alt="">

                    <div class="ElementTitleNameBox">
                        <img src="img/id.png" alt="" class="ElementTitleNameIcon">
                        <p>{{report.name}}</p>
                    </div>

                    <div class="ElementTitleNumberBox">
                        <img src="img/phone.png" alt="" class="ElementTitleNumberIcon">
                        <p>{{report.number}}</p>
                    </div>

                    <div class="ElementTitleDateBox">
                        <img src="img/data.png" alt="" class="ElementTitleDateIcon">
                        <p>{{report.date}}</p>
                    </div>

                    <div class="ElementButton"
                        v-on:click="goBack"
                    >
                        {{translate.TR_BACK}}
                    </div>
                </div>

                <div class="ElementBox">
                    <div class="ElementTextBox">
                        <p class="ElementText">{{translate.TR_DESCRIPTION}}</p>
                        <p class="ElementDescription">{{report.description}}</p>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props:{
        report:{},
        OpenScreen:{},

        translate:{

        },
        close:{}
    },

    methods: {
        goBack: function(){
            this.OpenScreen('AllReports');
        }
    }
}
</script>

<style>
    
</style>