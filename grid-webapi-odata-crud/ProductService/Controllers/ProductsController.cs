using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using System.Web.Http.OData;
using System.Web.Http.OData.Routing;
using ProductService.Models;
using System.Web.Http.OData.Query;

namespace ProductService.Controllers
{
    [Queryable(
        AllowedQueryOptions = 
            AllowedQueryOptions.Format | 
            AllowedQueryOptions.Top | 
            AllowedQueryOptions.Skip |
            AllowedQueryOptions.InlineCount|
            AllowedQueryOptions.OrderBy
        )]
    public class ProductsController : ODataController
    {
        private ProductServiceContext db = new ProductServiceContext();

        // GET odata/Products        
        public IQueryable<Product> GetProducts()
        {
            return db.Products;
        }

        // PUT odata/Products(5)
        public HttpResponseMessage Put([FromODataUri] int key, Product product)
        {
            if (!ModelState.IsValid)
            {
                return Request.CreateResponse<ModelStateDictionary>(HttpStatusCode.BadRequest, ModelState);
            }

            db.Entry(product).State = EntityState.Modified;

            db.SaveChanges();


            return Request.CreateResponse<Product[]>(HttpStatusCode.OK, new[] { product });
        }

        // POST odata/Products
        public HttpResponseMessage Post(Product product)
        {
            if (!ModelState.IsValid)
            {
                return Request.CreateResponse<ModelStateDictionary>(HttpStatusCode.BadRequest, ModelState);
            }

            db.Products.Add(product);
            db.SaveChanges();

            return Request.CreateResponse<Product[]>(HttpStatusCode.Created, new[] { product });
        }

        // DELETE odata/Products(5)
        public async Task<IHttpActionResult> Delete([FromODataUri] int key)
        {
            Product product = await db.Products.FindAsync(key);
            if (product == null)
            {
                return NotFound();
            }
            //The DELETE statement conflicted with the REFERENCE constraint \"FK_Order_Details_Products\"
            db.Products.Remove(product);
            await db.SaveChangesAsync();

            return StatusCode(HttpStatusCode.NoContent);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
