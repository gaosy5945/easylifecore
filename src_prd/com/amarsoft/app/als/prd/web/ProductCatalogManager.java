package com.amarsoft.app.als.prd.web;


import java.util.List;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 页面逻辑运行类，通过在Function中定义一套执行类顺序，逐个进行运行，以达到数据处理的独立。
 * <li>可通过权限等进行控制，使不同的逻辑在不同的地方进行执行。
 * <li>作为一个function的原则最好是逻辑独立，外部只注重输入和输出。
 * @author Administrator
 *
 */
public class ProductCatalogManager extends WebBusinessProcessor{

	public String newProductCatalog(String productCatalogID, String productCatalogName) throws Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		
		BusinessObject catalog = bm.loadBusinessObject("jbo.sys.CODE_LIBRARY", "ProductCatalog",productCatalogID);
		if(catalog!=null) throw new Exception("该产品类型已经存在!");
		
		BizObjectManager cl = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		if(this.getBusinessObjectManager().getTx()!=null)
			this.getBusinessObjectManager().getTx().join(cl);
		String maxSortNo = cl.createQuery("select max(SortNo)  as v.MSN from O where O.CODENO=:CODENO").setParameter("CODENO", "ProductCatalog").getSingleResult(false).getAttribute("MSN").getString();
		String newMaxSortNo = String.valueOf(Integer.parseInt(maxSortNo)+10);
		while(newMaxSortNo.length() < 4){
			newMaxSortNo = "0"+newMaxSortNo;
		}
		
		BusinessObject newCatalog = BusinessObject.createBusinessObject("jbo.sys.CODE_LIBRARY");
		newCatalog.setAttributeValue("CodeNo", "ProductCatalog");
		newCatalog.setAttributeValue("ItemNo", productCatalogID);
		newCatalog.setAttributeValue("ItemName", productCatalogName);
		newCatalog.setAttributeValue("SortNo", newMaxSortNo);
		newCatalog.setAttributeValue("IsInUse", "1");
		newCatalog.setAttributeValue("InputTime", DateHelper.getBusinessTime());
		newCatalog.setAttributeValue("UpdateTime", DateHelper.getBusinessTime());
		bm.updateBusinessObject(newCatalog);
		bm.updateDB();
		return "1";
	}
	
	public String newProductType(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String productCatalogID = getStringValue("ProductCatalog");
		String productTypeID = getStringValue("ProductType");
		String productTypeName = getStringValue("ProductTypeName");
		String parentProductTypeID = getStringValue("ParentProductType");
		return this.newProductType(productCatalogID, productTypeID, productTypeName, parentProductTypeID);
	}
	
	public String newProductType(String productCatalogID,String productTypeID,String productTypeName,String parentProductTypeID) throws Exception{
		if(this.getProductType(productCatalogID, productTypeID)!= null){
			return "2";
		}
		BusinessObjectManager bm = getBusinessObjectManager();
		BusinessObject bo = BusinessObject.createBusinessObject(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG);
		bo.setAttributeValue("PRODUCTTYPE", productTypeID);
		bo.setAttributeValue("PRODUCTTYPENAME", productTypeName);
		bo.setAttributeValue("PARENTPRODUCTTYPE", parentProductTypeID);
		bo.setAttributeValue("PRODUCTCATALOG", productCatalogID);
		bo.setAttributeValue("SORTNO", this.getProductTypeSortNO(productCatalogID, parentProductTypeID));
		bm.updateBusinessObject(bo);
		bm.updateDB();
		return "1";
	}
	
	public BusinessObject getProductType(String productCatalogID,String productTypeID) throws Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		List<BusinessObject> list = bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG, "ProductType =:PRODUCTTYPE and PRODUCTCATALOG=:PRODUCTCATALOG"
				, "PRODUCTCATALOG",productCatalogID,"PRODUCTTYPE",productTypeID);
		if(list.isEmpty())
			return null;
		return list.get(0);
	}
	
	public List<BusinessObject> getProductList(String productCatalogID,String productTypeID) throws Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		List<BusinessObject> list = bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW, "ProductType =:PRODUCTTYPE and PRODUCTCATALOG=:PRODUCTCATALOG"
				, "PRODUCTCATALOG",productCatalogID,"PRODUCTTYPE",productTypeID);
		return list;
	}
	
	public String getProductTypeSortNO(String productCatalogID,String parentProductTypeID) throws Exception{
		String sortNo="";
		BusinessObjectManager bm = getBusinessObjectManager();
		if(StringX.isEmpty(parentProductTypeID)){
			List<BusinessObject> l = bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG, 
					"ProductCatalog='"+productCatalogID+"' and (PARENTPRODUCTTYPE is null or PARENTPRODUCTTYPE = '') order by SortNo desc");
			if(l==null||l.isEmpty())return "01";
			else sortNo=l.get(0).getString("SortNo");
		}
		else{
			BusinessObject parentProductType=this.getProductType(productCatalogID, parentProductTypeID);
			List<BusinessObject> l = bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG, 
					"ProductCatalog='"+productCatalogID+"' and PARENTPRODUCTTYPE ='"+parentProductTypeID+"' order by SortNo desc");
			if(l==null||l.isEmpty())return parentProductType.getString("SortNo")+"01";
			else sortNo=parentProductType.getString("SortNo")+l.get(0).getString("SortNo");
		}
		return Integer.parseInt(sortNo) + 10+ "";
	}
	
	public String deleteProductType(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String productCatalogID = getStringValue("ProductCatalog");
		String productTypeID = getStringValue("ProductType");
		return this.deleteProductType(productCatalogID, productTypeID);
	}
	
	public String deleteProductType(String productCatalogID,String productTypeID) throws Exception{
		BusinessObject productType=this.getProductType(productCatalogID, productTypeID);
		BusinessObjectManager bm = getBusinessObjectManager();
		bm.deleteBusinessObjects(bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW, 
				"PRODUCTTYPE in (select p.PRODUCTTYPE from jbo.prd.PRD_VIEW_CATALOG p where p.SortNo like :SORTNO and P.PRODUCTCATALOG='"+productCatalogID+"') and PRODUCTCATALOG=:PRODUCTCATALOG ",
				"PRODUCTCATALOG",productCatalogID,"SORTNO",productType.getString("SortNo")+"%"));
		bm.deleteBusinessObjects(bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW_CATALOG,
				"SortNo like :SORTNO and PRODUCTCATALOG=:PRODUCTCATALOG",
				"PRODUCTCATALOG",productCatalogID,"SORTNO",productType.getString("SortNo")+"%"));
		bm.updateDB();
		return "1";
	}
	
	public String modifyProductTypeParent(String productCatalogID , String productTypeID , String newParentProductTypeID) throws Exception{
		return "1";
	}
	
	public String modifyProductType(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String productCatalogID = getStringValue("ProductCatalog");
		String productTypeID = getStringValue("ProductType");
		String newProductTypeName = getStringValue("NewProductTypeName");
		return this.modifyProductType(productCatalogID, productTypeID, newProductTypeName);
	}
	
	public String modifyProductType(String productCatalog , String productTypeID , String newProductTypeName) throws Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		BusinessObject productType = this.getProductType(productCatalog, productTypeID);
		productType.setAttributeValue("PRODUCTTYPENAME", newProductTypeName);
		bm.updateBusinessObject(productType);
		bm.updateDB();
		return "1";
	}
	
	/**
	 * 将产品引入指定产品目录下
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String importProduct(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String productCatalogID = getStringValue("ProductCatalog");
		String productTypeID = getStringValue("ProductType");
		String productIDString = getStringValue("ProductIDString");
		return this.importProduct(productCatalogID, productTypeID, productIDString);
	}
	
	/**
	 * 将产品引入指定产品目录下
	 * @param productCatalogID
	 * @param productTypeID
	 * @param productIDString
	 * @return
	 * @throws Exception
	 */
	public String importProduct(String productCatalogID,String productTypeID,String productIDString) throws  Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		bm.deleteBusinessObjects(bm.loadBusinessObjects(ProductConfig.PRODUCT_CONFIG_VIEW, "ProductCatalog=:ProductCatalog and ProductID in (:ProductID)"
				, "ProductCatalog",productCatalogID,"ProductID",productIDString.split("@")));
		for(String productID : productIDString.split("@")){
			BusinessObject o = BusinessObject.createBusinessObject(ProductConfig.PRODUCT_CONFIG_VIEW);
			o.setAttributeValue("PRODUCTID", productID);
			o.setAttributeValue("PRODUCTTYPE", productTypeID);
			o.setAttributeValue("PRODUCTCATALOG", productCatalogID);
			bm.updateBusinessObject(o);
		}
		bm.updateDB();
		return "1";
	}
	
	
	/**
	 * 将产品从指定产品目录下删除
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String removeProduct(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String productCatalogID = getStringValue("ProductCatalog");
		String productTypeID = getStringValue("ProductType");
		String productIDString = getStringValue("ProductIDString");
		return this.removeProduct(productCatalogID, productTypeID, productIDString);
	}
	
	/**
	 * 将产品从指定产品目录下删除
	 * @param productCatalogID
	 * @param productTypeID
	 * @param productIDString
	 * @return
	 * @throws Exception
	 */
	public String removeProduct(String productCatalogID,String productTypeID,String productIDString) throws  Exception{
		BusinessObjectManager bm = getBusinessObjectManager();
		List<BusinessObject> l = bm.loadBusinessObjects(
				ProductConfig.PRODUCT_CONFIG_VIEW, "PRODUCTID in (:PRODUCTID) and PRODUCTTYPE=:PRODUCTTYPE and PRODUCTCATALOG=:PRODUCTCATALOG",
				"PRODUCTID",productIDString.split("@"),"PRODUCTTYPE",productTypeID,"PRODUCTCATALOG",productCatalogID.split("@"));
		bm.deleteBusinessObjects(l);
		bm.updateDB();
		return "1";
	}
}
