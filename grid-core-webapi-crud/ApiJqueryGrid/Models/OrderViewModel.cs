using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ApiJqueryGrid.Models
{
    public class OrderViewModel
    {
        public int OrderID
        {
            get;
            set;
        }

        public Category Category
        {
            get;
            set;
        }

        [Required]
        public DateTime? OrderDate
        {
            get;
            set;
        }

        public string ShipCity
        {
            get;
            set;
        }

        public string ShipName
        {
            get;
            set;
        }
    }
}
