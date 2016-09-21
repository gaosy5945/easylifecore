package com.amarsoft.app.als.prd.config.loader;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 当新增或修改产品大类与小类映射关系时判断输入的产品大类、小类是否存在
 * @author 张万亮
 *
 */
public class BusinessTypeCoreQuery{
	
	private String itemNo;
	private String attribute2;
	private String oldItemNo;

	public String getOldItemNo() {
		return oldItemNo;
	}

	public void setOldItemNo(String oldItemNo) {
		this.oldItemNo = oldItemNo;
	}

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getAttribute2() {
		return attribute2;
	}

	public void setAttribute2(String attribute2) {
		this.attribute2 = attribute2;
	}

	public String query(JBOTransaction tx) throws Exception{
		
		String flag = "true";
		String msg = "";
		if(oldItemNo == null) oldItemNo = "";
		if(itemNo == null) itemNo = "";
		if(attribute2 == null) attribute2 = "";
		if(!oldItemNo.equals(itemNo)){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			tx.join(bm);
			BizObjectQuery query = bm.createQuery("CodeNo = 'BusinessType_Core' and ItemNo = :ItemNo").setParameter("ItemNo", itemNo);
			@SuppressWarnings("unchecked")
			List<BizObject> list = query.getResultList(false);
			if(list!=null) {
				String sItemNo =list.get(0). getAttribute("ItemNo").getString();
				if(sItemNo == null) sItemNo = "";
				if(sItemNo.equals(itemNo)){
					flag = "false";
					msg += "您输入的贷款小类【"+itemNo+"】已经存在，请重新输入！";
				}
			}
		}
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
		tx.join(bom);
		BizObjectQuery boq = bom.createQuery("ProductID = :ProductID and ProductType1 = '01'").setParameter("ProductID", attribute2);
		@SuppressWarnings("unchecked")
		List<BizObject> list = boq.getResultList(false);
		if(list!=null){
			String ProductID = list.get(0).getAttribute("ProductID").getString();
			if(ProductID == null){
				flag = "false";
				msg += "您输入的贷款大类【"+attribute2+"】未在产品中配置，请先在产品中配置！";
			}
		}
		return flag+"@"+msg;
	}
}
