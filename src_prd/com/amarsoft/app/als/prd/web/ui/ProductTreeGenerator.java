package com.amarsoft.app.als.prd.web.ui;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.ui.treeview.TreeGenerator;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;

public class ProductTreeGenerator extends TreeGenerator{

	@Override
	public List<BusinessObject> getTreeItemList(Page curPage) throws Exception {
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		
		String productFilter = " Status in ('1','0') and O.ProductID not in('555') ";
		List<Object> productFilterParameter = new ArrayList<Object>();
		String projectProductID=(String)getInputParameter("ProjectProductID");
		if(!StringX.isEmpty(projectProductID)){
			productFilter+=" and O.ProductID in (select PR.ObjectNo from "+ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE+" PR "
					+ " where PR.ProductID=:ProjectProductID and PR.ObjectType='"+ProductConfig.PRODUCT_CONFIG_PRODUCT+"' and PR.RelativeType='01') ";
			productFilterParameter.add("ProjectProductID");
			productFilterParameter.add(projectProductID);
		}
		
		String clcontractSerialNo = (String)getInputParameter("CLContractSerialNo");
		String productType1=(String)getInputParameter("ProductType1");
		if(!StringX.isEmpty(productType1)){
			productFilter+=" and ProductType1 in (:ProductType1) ";
			productFilterParameter.add("ProductType1");
			productFilterParameter.add(productType1);
		}
		String productType2=(String)getInputParameter("ProductType2");
		if(!StringX.isEmpty(productType2) && StringX.isEmpty(clcontractSerialNo)){
			productFilter+=" and ProductType2 in (:ProductType2) ";
			productFilterParameter.add("ProductType2");
			productFilterParameter.add(productType2);
		}
		String productType3=(String)getInputParameter("ProductType3");
		if(!StringX.isEmpty(productType3)){
			productFilter+=" and ProductType3 in (:ProductType3) ";
			productFilterParameter.add("ProductType3");
			productFilterParameter.add(productType3);
		}
		String status=(String)getInputParameter("Status");
		if(!StringX.isEmpty(status)){
			productFilter+=" and status in (:ProductStatus) ";
			productFilterParameter.add("ProductStatus");
			productFilterParameter.add(status);
		}
		
		if(!StringX.isEmpty(clcontractSerialNo)){
			String validProductID = this.getCreditLinProduct(clcontractSerialNo);
			if(!StringX.isEmpty(validProductID)){
				productFilter+=" and ProductID in (:ValidProductID) ";
				productFilterParameter.add("ValidProductID");
				productFilterParameter.add(validProductID.split(","));
			}
		}
		else{
			productFilter+=" and O.ProductID not in('666') ";
		}
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> productList= bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_PRODUCT, productFilter,productFilterParameter.toArray(new Object[0]));
		
		String productCatalog=(String)getInputParameter("ProductCatalog");
		if(StringX.isEmpty(productCatalog)){
			productCatalog=ProductConfig.PRODUCT_CATALOG_DEFAULT;
		}

		List<BusinessObject> productViewCatalogList= bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG, "ProductCatalog=:ProductCatalog order by SortNo"
				,"ProductCatalog",productCatalog);
		
		List<BusinessObject> productViewLibraryList= bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW, "ProductCatalog=:ProductCatalog order by ProductType,ProductID"
				,"ProductCatalog",productCatalog);
		
		for(BusinessObject productView:productViewCatalogList){
			String productType=productView.getString("ProductType");
			List<BusinessObject> productTypeViewList=BusinessObjectHelper.getBusinessObjectsByAttributes(productViewLibraryList, "ProductType",productType);
			if(productTypeViewList.isEmpty()) continue;
			String productTypeSortNo=productView.getString("SortNo");
			
			List<BusinessObject> productItemList = new ArrayList<BusinessObject>();
			for(BusinessObject productTypeView:productTypeViewList){
				String productID = productTypeView.getString("ProductID");
				
				BusinessObject product = BusinessObjectHelper.getBusinessObjectByAttributes(productList, "ProductID",productID);
				if(product==null) continue;
				BusinessObject item=BusinessObject.createBusinessObject();
				item.setAttributeValue(getKeyAttributeID() , productID);
				item.setAttributeValue(getNameAttributeID() , product.getString("ProductName"));
				item.setAttributeValue(getSortAttributeID() , productTypeSortNo+"-"+productID);
				productItemList.add(item);
			}
			if(productItemList.isEmpty()) continue;
			BusinessObject item=BusinessObject.createBusinessObject();
			item.setAttributeValue(getKeyAttributeID() , productType);
			item.setAttributeValue(getNameAttributeID() , productView.getString("ProductTypeName"));
			item.setAttributeValue(getSortAttributeID() , productTypeSortNo);
			list.add(item);
			list.addAll(productItemList);
		}
		return list;
	}
	
	private String getCreditLinProduct(String clcontractSerialNo) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject clcontract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", clcontractSerialNo);
		if(clcontract==null) return "";
		String value = ProductAnalysisFunctions.getComponentOptionalValue(clcontract, "PRD02-10", "CLProductID", "0010", "02");
		return value;
	}

	@Override
	public String getKeyAttributeID() {
		return "ID";
	}

	@Override
	public String getNameAttributeID() {
		return "Name";
	}

	@Override
	public String getSortAttributeID() {
		return "SortNo";
	}
	
	

}
