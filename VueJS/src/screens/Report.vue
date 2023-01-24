<template>
    <div>
        <div class="ReportBody Report">
            <p class="ExitButton" v-on:click="close()">X</p>
            <div class="ReportTitleBox">
                <img src="img/simbol.png" alt="" class="ReportTitleImage">
                <p class="ReportTitleText">{{translate.TR_POLICEREPORT}}</p>
            </div>

            <div class="ReportFormBox">
                <div class="ReportFormCellBox">
                    <label for="ReportFormNameInput" >{{translate.TR_NAME}}</label>
                    <input type="text" id="ReportFormNameInput" class="ReportFormName" v-model="name" readonly>
                </div>
                <div class="ReportFormCellBox">
                    <label for="ReportFormNumberInput">{{translate.TR_PHONE}}</label>
                    <input type="text" id="ReportFormNumberInput" class="ReportFormNumberInput" v-model="number">
                </div>

                <div class="ReportFormCellBox ReportTextAreaBox">
                    <label for="ReportFormReportInput">{{translate.TR_REPORT}}</label>
                    <textarea id="ReportFormReportInput" class="ReportFormReportInput" v-model="description"></textarea>
                </div>

                <div class="ReportFormCheckBox">
                    <input type="checkbox" id="ReportFormAnonymous" class="ReportFormAnonymous" v-model="anonymous">
                    <label for="ReportFormAnonymous">{{translate.TR_ANONYMOUS}}</label>
                </div>

                <div class="ReportFormButton"
                    v-on:click="saveReport"
                >
                    {{translate.TR_TOREPORT}}
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props:{
        translate:{},
        close:{},
        namePlayer: {},
        NameResource: {}
    },

    data: function(){
        return({
            name: "",
            number: "",
            description: "",
            anonymous: false
        })
    },

    methods:{
        saveReport: function(){
            if(this.description.length > 2){
                fetch(`https://${this.NameResource}/saveReport`, {
                    method: 'POST',
                    body: JSON.stringify({
                        name: this.name,
                        number: this.number,
                        description: this.description,
                        anonymous: this.anonymous
                    })
                }); 

                this.close();
            }
        }
    },
    created: function(){
        this.name = this.namePlayer;
    }
}
</script>