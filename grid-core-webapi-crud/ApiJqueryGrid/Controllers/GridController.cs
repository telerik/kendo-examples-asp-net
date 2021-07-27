using ApiJqueryGrid.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ApiJqueryGrid.Controllers
{
    [Route("api/[controller]")]
    public class GridController : ControllerBase
    {
        private static List<OrderViewModel> orders;

        [HttpGet("Read")]
        public DataSourceResult GetOrders([DataSourceRequest] DataSourceRequest request)
        {
            if (orders == null)
            {
                orders = Enumerable.Range(1, 50).Select(i => new OrderViewModel
                {
                    OrderID = i,
                    Category = new Category() { CategoryID = 2, CategoryName = "Delivered" },
                    OrderDate = new DateTime(2016, 9, 15).AddDays(i % 7),
                    ShipName = "ShipName " + i,
                    ShipCity = "ShipCity " + i
                }).ToList();
            }


            return orders.ToDataSourceResult(request);
        }

        [HttpPost("Create")]
        public IActionResult Create(OrderViewModel order)
        {
            order.OrderID = orders.Count + 1;
            orders.Add(order);

            return new ObjectResult(new DataSourceResult { Data = new[] { order }, Total = 1 });
        }

        [HttpPut("Update")]
        public IActionResult Update(OrderViewModel order)
        {

            return new StatusCodeResult(200);
        }

        [HttpDelete("Destroy")]
        public IActionResult Destroy(OrderViewModel order)
        {
            orders.Remove(order);

            return new StatusCodeResult(200);
        }
    }
}
