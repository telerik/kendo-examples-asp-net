<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="http://cdn.kendostatic.com/2012.1.322/styles/kendo.common.min.css" rel="stylesheet" />
    <link href="http://cdn.kendostatic.com/2012.1.322/styles/kendo.blueopal.min.css" rel="stylesheet" />
    <script src="http://cdn.kendostatic.com/2012.1.322/js/kendo.all.min.js"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<%-- MVVM grid initalization --%>
<div id="grid" 
    data-role="grid" 
    data-bind="source: gridSource" 
    data-editable="true" 
    data-columns='["ProductName", { "field": "UnitPrice", "format": "{0:c}", "width": "150px" }, { "field": "UnitsInStock", "width": "150px" }, { "field": "Discontinued", "width": "100px" }, { "command": "destroy", "title": "Delete", "width": "110px" }]' 
    data-toolbar='["create", "save", "cancel"]'
    data-pageable="true"></div>


<p>
    You need to paste the following in your web.config in order to allow HTTP GET and HTTP POST for the ASMX service:
</p>
<pre>
  &lt;webServices&gt;
      &lt;protocols&gt;
          &lt;add name="HttpGet"/&gt;
          &lt;add name="HttpPost"/&gt;
      &lt;/protocols&gt;
  &lt;/webServices&gt;
</pre>
<p>
    Find more info <a href="http://support.microsoft.com/default.aspx?scid=kb;en-us;819267">here (MSDN)</a>.
</p>
<p>
    For more info about consuming ASP.NET Web Services from jQuery check <a href="http://encosia.com/using-jquery-to-consume-aspnet-json-web-services/">this</a> blog post.
</p>
</asp:Content>
<asp:Content ID="FooterContent" runat="server" ContentPlaceHolderID="FooterContent">
    <script>

        var dataSource = new kendo.data.DataSource({
            schema: {
                data: function (data) { //specify the array that contains the data
                    return data.d.Data || [];
                },
                total: "d.Total", //define total number of records, needed for server paging
                model: { // define the model of the data source. Required for validation and property types.
                    id: "ProductID",
                    fields: {
                        ProductID: { editable: false, nullable: true },
                        ProductName: { validation: { required: true} },
                        UnitPrice: { type: "number", validation: { required: true, min: 1, max: 999} },
                        Discontinued: { type: "boolean" },
                        UnitsInStock: { type: "number", validation: { min: 0, required: true} }
                    }
                }
            },
            batch: true, // enable batch editing - changes will be saved when the user clicks the "Save changes" button
            transport: {
                create: {
                    url: "Products.asmx/Create", //specify the URL which should create new records. This is the Create method of the Products.asmx service.
                    contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                    type: "POST" //use HTTP POST request as the default GET is not allowed for ASMX
                },
                read: {
                    url: "Products.asmx/Read", //specify the URL which data should return the records. This is the Read method of the Products.asmx service.
                    contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                    type: "POST" //use HTTP POST request as the default GET is not allowed for ASMX
                },
                update: {
                    url: "Products.asmx/Update", //specify the URL from which should update the records. This is the Update method of the Products.asmx service.
                    contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                    type: "POST" //use HTTP POST request as the default GET is not allowed for ASMX
                },
                destroy: {
                    url: "Products.asmx/Destroy", //specify the URL which should destroy records. This is the Destroy method of the Products.asmx service.
                    contentType: "application/json; charset=utf-8", // tells the web service to serialize JSON
                    type: "POST" //use HTTP POST request as the default GET is not allowed for ASMX
                },
                parameterMap: function (data, operation) {
                    if (operation != "read") {
                        // web service method parameters need to be send as JSON. The Create, Update and Destroy methods have a "products" parameter.
                        return JSON.stringify({ products: data.models })
                    } else {
                        return JSON.stringify(data); //return stringified options to the server
                    }
                }
            },
            serverPaging: true,
            pageSize: 15
        });

        //define a viewModel
        var viewModel = kendo.observable({
            gridSource: dataSource
        });

        //bind the body to the viewModel
        kendo.bind($("body"), viewModel);
    </script>
</asp:Content>
