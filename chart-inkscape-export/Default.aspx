<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="chart_inkscape_export._Default" %>

<asp:Content runat="server" ID="HeadContent" ContentPlaceHolderID="HeadContent">
    <link href="http://cdn.kendostatic.com/2014.1.318/styles/kendo.common.min.css" rel="stylesheet" />
    <link href="http://cdn.kendostatic.com/2014.1.318/styles/kendo.default.min.css" rel="stylesheet" />
    <link href="http://cdn.kendostatic.com/2014.1.318/styles/kendo.dataviz.min.css" rel="stylesheet" />
    <link href="http://cdn.kendostatic.com/2014.1.318/styles/kendo.dataviz.default.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script src="http://cdn.kendostatic.com/2014.1.318/js/kendo.all.min.js"></script>
    <div>
        <button class="export" data-format="png">
            Export to PNG
        </button>
        <button class="export" data-format="pdf">
            Export to PDF
        </button>
    </div>
    <div id="chart" style="width: 800px; height: 600px">
    </div>
    <asp:HiddenField runat="server" ID="SVG" />
    <asp:HiddenField runat="server" ID="Format" />
    <script>
        function createChart() {
            $("#chart").kendoChart({
                theme: $(document).data("kendoSkin") || "default",
                title: {
                    text: "Internet Users"
                },
                legend: {
                    position: "bottom"
                },
                chartArea: {
                    background: ""
                },
                seriesDefaults: {
                    type: "bar"
                },
                series: [{
                    name: "World",
                    data: [15.7, 16.7, 20, 23.5, 26.6]
                }, {
                    name: "United States",
                    data: [67.96, 68.93, 75, 74, 78]
                }],
                valueAxis: {
                    labels: {
                        format: "{0}%"
                    }
                },
                categoryAxis: {
                    categories: [2005, 2006, 2007, 2008, 2009]
                },
                tooltip: {
                    visible: true,
                    format: "{0}%"
                }
            });
        }

        $(document).ready(function () {
            createChart();
            $(".export").click(function () {
                var chart = $("#chart").data("kendoChart");
                var svgString = escape(chart.svg());
                var exportFormat = $(this).data("format");

                $("#<%= SVG.ClientID %>").val(svgString);
                $("#<%= Format.ClientID %>").val(exportFormat);
            });
        });
    </script>

</asp:Content>
