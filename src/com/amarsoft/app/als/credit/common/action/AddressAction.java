package com.amarsoft.app.als.credit.common.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.cache.CodeCache;

public class AddressAction {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	//省、市、区
	public String splitAdd(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String itemNo = (String)inputParameter.getValue("ItemNo");
		String itemName = (String)inputParameter.getValue("ItemName");
		return this.splitAdd(itemNo,itemName);
	}
	
	public String splitAdd(String itemNo,String itemName) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		String province = itemNo.substring(0, 2)+"0000";
		String city = itemNo.substring(0,4)+"00";
		BusinessObject address1 = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "AreaCode",province);
		String provinceName = address1.getString("ItemName");//北京市
		BusinessObject address2 = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "AreaCode",city);
		String cityName1 = address2.getString("ItemName");//北京市市辖区
		String cityName2 = cityName1.replace(provinceName, "");

		String areaName = itemName.replace(cityName1, "");
		return provinceName+"@"+cityName2+"@"+areaName;
	}
	
	public String getAdd(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String province = (String)inputParameter.getValue("Province");
		String city = (String)inputParameter.getValue("City");
		String area = (String)inputParameter.getValue("Area");
		return this.getAdd(province,city,area);
	}
	
	public String getAdd(String province,String city,String area) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();

		BusinessObject address1 = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "CodeNo","AreaCode","ItemNo",province);
		if(address1 == null) return "false";
		String provinceName = address1.getString("ItemName");//北京市
		BusinessObject address2 = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "CodeNo","AreaCode","ItemNo",city);
		if(address2 == null) return "false";
		String cityName = address2.getString("ItemName");//北京市市辖区
		BusinessObject address3 = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "CodeNo","AreaCode","ItemNo",area);
		if(address3 == null) return "false";
		String areaName = address3.getString("ItemName");//北京市市辖区

		return provinceName+"@"+cityName+"@"+areaName;
	}
	
	public String getCountry(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String country = (String)inputParameter.getValue("Country");
		if(country.equals(""))
			return "false";
		return this.getCountry(country);
	}
	
	public String getCountry(String country) throws Exception{
		
		String countryName = CodeCache.getItem("CountryCode",country).getItemName();

		return countryName;
	}
	
	public String concatAdd(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String province = (String)inputParameter.getValue("Province");
		String city = (String)inputParameter.getValue("City");
		String area = (String)inputParameter.getValue("Area");
		if(province.equals("")||city.equals("")||area.equals(""))
			return "false";
		return this.concatAdd(province,city,area);
	}
	
	public String concatAdd(String province,String city,String area) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();

		BusinessObject address = bomanager.loadBusinessObject("jbo.sys.CODE_LIBRARY", "AreaCode",province+city+area);
		String addressName = address.getString("ItemName");

		return addressName;

	}
}