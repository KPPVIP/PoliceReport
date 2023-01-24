<template>
    <div id="App">
        <div class="Notify" v-if="hasNotify">{{notify}}</div>
        <div :class="{Closed: !openned}">
        <Report v-if="page == 'Report'" :namePlayer="namePlayer" :translate="translate" :NameResource="NameResource" :close="close"/>
        <AllReports v-else-if="page == 'AllReports'" :reports="reports" :setSelectedReport="setSelectedReport" :OpenScreen="OpenScreen" :translate="translate" :close="close"/>
        <Element v-else-if="page == 'Element'" :report="selected_report" :OpenScreen="OpenScreen" :translate="translate" :close="close"/>
        </div>
    </div>
</template>

<script>
import Report from './screens/Report';
import AllReports from './screens/AllReports';
import Element from './screens/Element';

export default {
    components:{
        Report,
        AllReports,
        Element
    },

    data: function(){
        return({
            page : "",

            reports: [
                {name: "zFightx", number: "0000-0000", date: "20/11/1998", description: "Estava andando pela rua da praça quando um sujeito de blusa marrom e chapéu  verde me abordou com uma faca. O mesmo disse para que eu passasse todos os meus pertences para ele. Com muito medo, passei tudo. No total perdi R$ 10000, um pudim e um hambúrguer."},
            ],
            selected_report: {},

            notify: "Notificação",

            translate: {
                TR_NAME : "Nome:",
                TR_PHONE: "Número de telefone:",
                TR_REPORT: "Ocorrência:",
                TR_ANONYMOUS: "Anonymous?",
                TR_TOREPORT: "Reportar",
                TR_POLICEREPORT: "Boletim de Ocorrência:",
                TR_REPORTS: "Ocorrências:",
                TR_DESCRIPTION: "Descrição:",
                TR_BACK: "Voltar",
            },

            namePlayer: "",
            NameResource: "PoliceReport",
            openned : false,
            hasNotify: false,
            timeout : null
        })
    },

    methods:{
        OpenScreen: function(name){
            this.page = name;
        },

        setSelectedReport(report){
            this.selected_report = report;
        },

        close: function(){
            fetch(`https://${this.NameResource}/close`, {
                method: 'POST',
                body: JSON.stringify({})
            }); 

            this.page = "";
            this.openned = false;
        },

        hiddenNotify: function(){
            this.hasNotify = false;
            this.timeout = null;
        },

        keyPress: function(event){
            const key = event.key;
            
            if(key == "Escape"){
                this.close();
            }
        },

        receiveLua: function(event){
            if(!event || !event.data)
                return;
            
            const lua = event.data;

            if(lua.config){
                this.translate = lua.translate;
                this.NameResource = lua.NameResource;
            }

            else if(lua.openReport){
                this.namePlayer = lua.namePlayer;
                this.OpenScreen('Report');
                this.openned = true;
            }

            else if(lua.openAllReports){
                this.reports = lua.reports;
                this.OpenScreen('AllReports');
                this.openned = true;
            }

            else if(lua.Notify){
                this.notify = lua.Notify;
                this.hasNotify = true;

                if(this.timeout)
                    clearTimeout(this.timeout);

                this.timeout = setTimeout(this.hiddenNotify, 5000);
            }

        }
    },

    created: function(){
        window.addEventListener('message', this.receiveLua);  
        window.addEventListener('keydown', this.keyPress);
    },
    destroyed: function(){
        window.removeEventListener('message', this.receiveLua);
        window.removeEventListener('keydown', this.keyPress);
    }
}
</script>

<style>
    .Closed{
        display: none;
    }

    #App{
        overflow: hidden;
    }
</style>