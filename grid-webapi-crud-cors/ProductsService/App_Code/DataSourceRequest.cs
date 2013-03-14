using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class DataSourceRequest
{
    public int Take { get; set; }
    public int Skip { get; set; }
    public IEnumerable<Sort> Sort { get; set; }
    public Filter Filter { get; set; }
}
