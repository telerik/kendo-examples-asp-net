<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%-- kendo.common.min.css contains common CSS rules used by all Kendo themes --%>
    <link href="http://cdn.kendostatic.com/2011.3.1129/styles/kendo.common.min.css" rel="stylesheet" />
    <%-- kendo.blueopal.min.css contains the "Blue Opal" Kendo theme --%>
    <link href="http://cdn.kendostatic.com/2011.3.1129/styles/kendo.blueopal.min.css"
        rel="stylesheet" />
    <script src="http://cdn.kendostatic.com/2011.3.1129/js/kendo.all.min.js"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<%-- The DIV where the Kendo grid will be initialized --%>
<div id="grid"></div>
</asp:Content>
<asp:Content ID="FooterContent" runat="server" ContentPlaceHolderID="FooterContent">
    <script>
        $(function () {
            $("#grid").kendoGrid({
                height: 200,
                columns: [
                    "ProductName",
                    { field: "UnitPrice", format: "{0:c}", width: "150px" },
                    { field: "UnitsInStock", width: "150px" },
                    { field: "Discontinued", width: "100px" },
                    { command: "destroy", title: "Delete", width: "110px" }
                ],
                editable: true, // enable editing
                toolbar: ["create", "save", "cancel"], // specify toolbar commands
                dataSource: {
                    schema: {
                        data: "d", // svc services return JSON in the following format { "d": <result> }. Specify how to get the result.
                        model: { // define the model of the data source. Required for validation and property types.
                            id: "ProductID",
                            fields: {
                                ProductID: { editable: false, defaultValue: 0 },
                                ProductName: { validation: { required: true } },
                                UnitPrice: { type: "number", validation: { required: true, min: 1 } },
                                Discontinued: { type: "boolean" },
                                UnitsInStock: { type: "number", validation: { min: 0, required: true } }
                            }
                        }
                    },
                    transport: {
                        create: {
                            url: "NorthwindContextService.svc/CreateProduct", //specify the URL which should create new records. This is the Create method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        read: {
                            url: "NorthwindContextService.svc/ReadProducts", //specify the URL which data should return the records. This is the Read method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        update: {
                            url: "NorthwindContextService.svc/UpdateProduct", //specify the URL from which should update the records. This is the Update method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        destroy: {
                            url: "NorthwindContextService.svc/DeleteProduct", //specify the URL which should destroy records. This is the Destroy method of the Products.svc service.
                            contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                            type: "POST" //use HTTP POST request as the default GET is not allowed for svc
                        },
                        parameterMap: function(data, operation) {
                            if (operation != "read") {
                                // web service method parameters need to be send as JSON. The Create, Update and Destroy methods have a "product" parameter.
                                return JSON.stringify({ product: data })
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
