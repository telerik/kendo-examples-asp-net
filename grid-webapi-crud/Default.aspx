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
                        data: "Data",
                        total: "Total",
                        model: {
                            id: "ProductID",
                            fields: {
                                ProductID: { editable: false, type: "number" },
                                ProductName: { validation: { required: true }, type: "string" },
                                UnitPrice: { type: "number", validation: { required: true, min: 1 } },
                                Discontinued: { type: "boolean" },
                                UnitsInStock: { type: "number", validation: { min: 0, required: true } }
                            }
                        }
                    },
                    batch: false,
                    transport: {
                        create: {
                            url: "api/products",
                            contentType: "application/json",
                            type: "POST"
                        },
                        read: {
                            url: "api/products",
                            contentType: "application/json"
                        },
                        update: {
                            url: function (product) {
                                return "api/products/" + product.ProductID;
                            },
                            contentType: "application/json",
                            type: "PUT"
                        },
                        destroy: {
                            url: function (product) {
                                return "api/products/" + product.ProductID;
                            },
                            contentType: "application/json",
                            type: "DELETE"
                        },
                        parameterMap: function (data, operation) {
                            return JSON.stringify(data);
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
