using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GridModel
/// </summary>
public class GridModel
{
    public IEnumerable<ProductViewModel> Data { get; set; }
    public int Total { get; set; }
}