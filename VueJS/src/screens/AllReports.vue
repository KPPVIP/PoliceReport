<template>
    <div>
        <div class="ReportBody">
            <p class="ExitButton" v-on:click="close()">X</p>
            <div class="AllReports">
                <div class="AllReportsTitleBox">
                    <img src="img/simbol.png" class="AllReportsTitleImage" alt="">
                </div>

                <div class="AllReportsBox">
                    <div class="AllReportsTextBox">
                        <p>{{translate.TR_REPORTS}}</p>
                    </div>

                    <div class="AllReportsListBox">
                        <ul class="AllReportsList">
                            <li class="AllReportsListItemBox"
                                v-for="(item,index) in reports"
                                :key="index"
                            >
                                <div class="AllReportsListItemClick" v-on:click="OpenItem(item)"></div>
                                <p class="AllReportsListItemName">{{item.name}}</p>
                                <p class="AllReportsListItemNumber">{{item.number}}</p>
                                <p class="AllReportsListItemDate">{{item.date}}</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props:{
        reports: {},
        translate:{

        },
        setSelectedReport:{

        },
        OpenScreen:{},
        close:{}
    },

    methods:{
        OpenItem: function(item){
            this.setSelectedReport(item);
            this.OpenScreen('Element');
        }
    }
}
</script>

<style>  

</style>