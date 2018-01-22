package com.example.duje.ezorder;

import java.util.Date;

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
}
