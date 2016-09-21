package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class KeyBusinessType extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String productID = (String)this.getAttribute("ProductID");
		String ProductName = "";
		String ProductID = "";
		int i = 0;
		//基础产品唯一性判断
		ASResultSet sr = Sqlca.getResultSet("select ProductID,ProductName from PRD_PRODUCT_LIBRARY where exists (select OBJECTNO from PRD_PRODUCT_RELATIVE where PRODUCTID = '"+productID+"' and ObjectNo = PRD_PRODUCT_LIBRARY.PRODUCTID and relativetype='01') ");
		while(sr.next()){
			ProductID = sr.getStringValue("ProductID");
			ProductName = sr.getStringValue("ProductName");
			i++;
		}
		sr.getStatement().close();
		if(i == 1){
			return "true@"+ProductID+"@"+ProductName;
		}else{
			return "false@";
		}
	}		
}
