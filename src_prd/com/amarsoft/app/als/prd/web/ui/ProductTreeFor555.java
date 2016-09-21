package com.amarsoft.app.als.prd.web.ui;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.ui.treeview.TreeGenerator;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;

public class ProductTreeFor555 extends TreeGenerator{

	public List<BusinessObject> getTreeItemList(Page curPage) throws Exception {
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		String productFilter = " Status in ('1','0') and O.ProductID not in('555') ";
		productFilter+=" and ProductType2 in ('1','2') and ProductType3 = '01' and Status = '1'";
		String projectProductID=(String)getInputParameter("ProjectProductID");
		List<BusinessObject> productList= null;
		if(!StringX.isEmpty(projectProductID)){
			productFilter+=" and O.ProductID in (select PR.ObjectNo from "+ProductConfig.PRODUCT_CONFIG_PRODUCT_RELATIVE+" PR "
					+ " where PR.ProductID=:ProjectProductID and PR.ObjectType='"+ProductConfig.PRODUCT_CONFIG_PRODUCT+"' and PR.RelativeType='01') ";
			productList = bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_PRODUCT, productFilter,"ProjectProductID",projectProductID);
		}
		
		String productType1=(String)getInputParameter("ProductType1");
		if(!StringX.isEmpty(productType1)){
			productFilter+=" and ProductType1 in (:ProductType1) ";
			productList = bomanager.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_PRODUCT, productFilter,"ProjectProductID",projectProductID,"ProductType1",productType1.split(","));
		}
		
		
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
			List<BusinessObject> productTypeViewList=BusinessObjectHelper.getBusinessObjectsBySql(productViewLibraryList, "ProductType=:ProductType","ProductType",productType);
			if(productTypeViewList.isEmpty()) continue;
			String productTypeSortNo=productView.getString("SortNo");
			
			List<BusinessObject> productItemList = new ArrayList<BusinessObject>();
			for(BusinessObject productTypeView:productTypeViewList){
				String productID = productTypeView.getString("ProductID");
				
				BusinessObject product = BusinessObjectHelper.getBusinessObjectBySql(productList, "ProductID=:ProductID","ProductID",productID);
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
		BusinessObject businessApply = BusinessObject.createBusinessObject();
		businessApply.setAttributeValue("BusinessType","555");
		businessApply.setAttributeValue("ProductID","555");
		String value = ProductAnalysisFunctions.getComponentOptionalValue(businessApply, "PRD02-10", "CLProductID", "0010", "02");
		return value;
	}

	public String getKeyAttributeID() {
		return "ID";
	}

	public String getNameAttributeID() {
		return "Name";
	}

	public String getSortAttributeID() {
		return "SortNo";
	}
	
	

}
