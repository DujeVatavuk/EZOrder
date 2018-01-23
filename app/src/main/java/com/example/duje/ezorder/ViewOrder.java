package com.example.duje.ezorder;

import java.util.Date;
import java.util.List;

/**
 * Created by duje on 23.1.2018..
 */

public class ViewOrder{
    public int Id;
    public int TableId;
    public String Remark;
    public Date Ordered;
    public float TotalPrice;
    public  boolean Processed;
    public List<ViewOrderItem> ViewOrderItemList;

    public ViewOrder() {}
}
