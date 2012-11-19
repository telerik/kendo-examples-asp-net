<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
     <%-- kendo.common.min.css contains common CSS rules used by all Kendo themes --%>
    <link href="http://cdn.kendostatic.com/2012.3.1114/styles/kendo.common.min.css" rel="stylesheet" />

    <%-- kendo.blueopal.min.css contains the "Blue Opal" Kendo theme --%>
    <link href="http://cdn.kendostatic.com/2012.3.1114/styles/kendo.default.min.css" rel="stylesheet" />

    <script src="http://cdn.kendostatic.com/2012.3.1114/js/kendo.all.min.js"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<%-- The DIV where the Kendo grid will be initialized --%>
<div id="grid"></div>
</asp:Content>
<asp:Content ID="FooterContent" runat="server" ContentPlaceHolderID="FooterContent">
    <script>
        $(function () {
            $("#grid").kendoGrid({
                height: 400,
                columns: [
                    "ProductName",
                    { field: "UnitPrice", format: "{0:c}", width: "150px" },
                    { field: "UnitsInStock", width: "150px" },
                    { field: "Discontinued", width: "100px" },
                    { command: "destroy", title: "Delete", width: "110px" }
                ],
                pageable: true,
                sortable: true,
                filterable: true,
                editable: true, // enable editing
                toolbar: ["create", "save", "cancel"], // specify toolbar commands
                dataSource: {
                    serverPaging: true,
                    serverFiltering: true,
                    serverSorting: true,
                    pageSize: 10,
                    schema: {
                        data: "d.Data", // svc services return JSON in the following format { "d": <result> }. Specify how to get the result.
                        total: "d.Total", 
                        model: { // define the model of the data source. Required for validation and property types.
                            id: "ProductID",
                            fields: {
                                ProductID: { editable: false, nullable: true },
                                ProductName: { validation: { required: true }, type: "string" },
                                UnitPrice: { type: "number", validation: { required: true, min: 1 } },
                                Discontinued: { type: "boolean" },
                                UnitsInStock: { type: "number", validation: { min: 0, required: true } }
                            }
                        }
                    },
                    batch: true, // enable batch editing - changes will be saved when the user clicks the "Save changes" button
                    transport: {
                        create: {
                            url: "Products.svc/Create", //specify the URL which should create new records. This is the Create method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        read: {
                            url: "Products.svc/Read", //specify the URL which data should return the records. This is the Read method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        update: {
                            url: "Products.svc/Update", //specify the URL from which should update the records. This is the Update method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        destroy: {
                            url: "Products.svc/Destroy", //specify the URL which should destroy records. This is the Destroy method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        parameterMap: function(data, operation) {
                            if (operation != "read") {
                                // web service method parameters need to be send as JSON. The Create, Update and Destroy methods have a "products" parameter.
                                return JSON.stringify({ products: data.models })
                            } else {
                                return JSON.stringify(data);
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
