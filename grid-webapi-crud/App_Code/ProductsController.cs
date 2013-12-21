using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NorthwindModel;
using Newtonsoft.Json;
using Kendo.DynamicLinq;

public class ProductsController : ApiController
{
    private NorthwindEntities db = new NorthwindEntities();

    public DataSourceResult Get(HttpRequestMessage requestMessage)
    {
        DataSourceRequest request = JsonConvert.DeserializeObject<DataSourceRequest>(
            // The request is in the format GET api/products?{take:10,skip:0} and ParseQueryString treats it as a key without value
            requestMessage.RequestUri.ParseQueryString().GetKey(0)
        );

        return db.Products
            //Entity Framework can page only sorted data
            .OrderBy(product => product.ProductID)
            .Select(product => new
        {
            // Skip the EntityState and EntityKey properties inherited from EF. It would break model binding.
            product.ProductID,
            product.ProductName,
            product.Discontinued,
            product.QuantityPerUnit,
            product.ReorderLevel,
            product.UnitPrice,
            product.UnitsInStock,
            product.UnitsOnOrder
        })
        .ToDataSourceResult(request.Take, request.Skip, request.Sort, request.Filter);
    }

    public HttpResponseMessage Update(int id, Product product)
    {
        if (ModelState.IsValid && id == product.ProductID)
        {
            db.Products.Attach(product);
            db.ObjectStateManager.ChangeObjectState(product, EntityState.Modified);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }
        else
        {
            return Request.CreateResponse(HttpStatusCode.BadRequest);
        }
    }

    public HttpResponseMessage Post(Product product)
    {
        if (ModelState.IsValid)
        {
            db.Products.AddObject(product);
            db.SaveChanges();

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, product);
            response.Headers.Location = new Uri(Url.Link("DefaultApi", new { id = product.ProductID }));
            return response;
        }
        else
        {
            return Request.CreateResponse(HttpStatusCode.BadRequest);
        }
    }

    public HttpResponseMessage Delete(int id)
    {
        Product product = db.Products.Single(p => p.ProductID == id);
        if (product == null)
        {
            return Request.CreateResponse(HttpStatusCode.NotFound);
        }

        db.Products.DeleteObject(product);

        try
        {
            db.SaveChanges();
        }
        catch (DbUpdateConcurrencyException)
        {
            return Request.CreateResponse(HttpStatusCode.NotFound);
        }

        return Request.CreateResponse(HttpStatusCode.OK, product);
    }

    protected override void Dispose(bool disposing)
    {
        db.Dispose();
        base.Dispose(disposing);
    }
}
