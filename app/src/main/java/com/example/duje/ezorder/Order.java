package com.example.duje.ezorder;

import java.util.Date;
import java.util.List;

/**
 * Created by duje on 22.1.2018..
 */

public class Order {
    private static final Order ourInstance = new Order();

    public static Order getInstance() {
        return ourInstance;
    }

    private Order() {
    }

    public int Id;
    public int TableId;
    public String Remark;
    public Date Ordered;
    public float TotalPrice;
    public List<ViewOrderItem> ViewOrderItemList;
}
