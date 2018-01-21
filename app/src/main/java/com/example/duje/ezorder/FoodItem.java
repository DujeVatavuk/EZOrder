package com.example.duje.ezorder;

/**
 * Created by duje on 21.1.2018..
 */

public class FoodItem {
    public int Id;
    public int FoodCategoryId;
    public String Name;
    public float Price;

    public FoodItem() { }
    public FoodItem(int Id, int FoodCategoryId, String Name, float Price) {
        this.Id = Id;
        this.FoodCategoryId = FoodCategoryId;
        this.Name = Name;
        this.Price = Price;
    }

}
