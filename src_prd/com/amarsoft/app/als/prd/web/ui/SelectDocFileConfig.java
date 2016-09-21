package com.amarsoft.app.als.prd.web.ui;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.als.ui.treeview.TreeGenerator;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;

public class SelectDocFileConfig extends TreeGenerator{

	public List<BusinessObject> getTreeItemList(Page curPage) throws Exception {
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		String objectNo=(String)getInputParameter("ObjectNo");
		String productFilter = "FileID not in(select DFC.Fileid from jbo.doc.DOC_FILE_CONFIG  DFC, jbo.doc.DOC_FILE_INFO DFI where DFC.FileFormat = '03' and DFC.Status = '1' and DFC.ImageFileID is not null AND DFC.FILEID = DFI.FILEID and DFI.OBJECTTYPE = 'contract' and DFI.ObjectNo = '"+objectNo+"') and O.FileFormat = '03' and O.Status = '1'";
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> productList = null;
		if(!StringX.isEmpty(objectNo)){
			
			String validProductID = this.getCreditLinProduct(objectNo);
			if(!StringX.isEmpty(validProductID)){
				productFilter+=" and FileID in (:ValidProductID) ";
				productList = bomanager.loadBusinessObjects("jbo.doc.DOC_FILE_CONFIG", productFilter,"ValidProductID",validProductID.split(","));
			}
		}else productList= bomanager.loadBusinessObjects("jbo.doc.DOC_FILE_CONFIG", productFilter);
		
		String productCatalog=(String)getInputParameter("ProductCatalog");
		if(StringX.isEmpty(productCatalog)){
			productCatalog=ProductConfig.PRODUCT_CATALOG_DEFAULT;
		}

		List<BusinessObject> productViewCatalogList= bomanager.loadBusinessObjects("jbo.doc.DOC_VIEW_CATALOG", "VIEWID in ('2014122300000003','2014122300000004','2014122300000007') order by FOLDERNAME");
		
		List<BusinessObject> productViewLibraryList= bomanager.loadBusinessObjects("jbo.doc.DOC_VIEW_FILE", "VIEWID in ('2014122300000003','2014122300000004','2014122300000007') order by FILEID");
		
		for(BusinessObject productView:productViewCatalogList){
			String VIEWID=productView.getString("VIEWID");
			List<BusinessObject> productTypeViewList=BusinessObjectHelper.getBusinessObjectsBySql(productViewLibraryList, "VIEWID=:VIEWID","VIEWID",VIEWID);
			if(productTypeViewList.isEmpty()) continue;
			String FOLDERNAME=productView.getString("FOLDERNAME");
			
			List<BusinessObject> productItemList = new ArrayList<BusinessObject>();
			for(BusinessObject productTypeView:productTypeViewList){
				String FILEID = productTypeView.getString("FILEID");
				
				BusinessObject product = BusinessObjectHelper.getBusinessObjectBySql(productList, "FILEID=:FILEID","FILEID",FILEID);
				if(product==null) continue;
				BusinessObject item=BusinessObject.createBusinessObject();
				item.setAttributeValue(getKeyAttributeID() , FILEID);
				item.setAttributeValue(getNameAttributeID() , product.getString("FILENAME"));
				item.setAttributeValue(getSortAttributeID() , FOLDERNAME+"-"+FILEID);
				productItemList.add(item);
			}
			if(productItemList.isEmpty()) continue;
			BusinessObject item=BusinessObject.createBusinessObject();
			item.setAttributeValue(getKeyAttributeID() , VIEWID);
			item.setAttributeValue(getNameAttributeID() , FOLDERNAME);
			item.setAttributeValue(getSortAttributeID() , FOLDERNAME);
			list.add(item);
			list.addAll(productItemList);
		}
		return list;
	}
	
	private String getCreditLinProduct(String objectNo) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", objectNo);
		if(contract==null) {
			List<BusinessObject> bos = bomanager.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "O.CONTRACTARTIFICIALNO=:ContractNo","ContractNo",objectNo);
			if(bos != null && !bos.isEmpty())
			{
				contract = bos.get(0);
			}
			else
			{
				throw new Exception("Œ¥’“µΩ∫œÕ¨∫≈°æ"+objectNo+"°ø");
			}
		}
		String value = ProductAnalysisFunctions.getComponentMandatoryValue(contract, "PRD04-01", "BusinessDocs", "0010", "01");
		value += ","+ProductAnalysisFunctions.getComponentOptionalValue(contract, "PRD04-01", "BusinessDocs", "0010", "01");
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
