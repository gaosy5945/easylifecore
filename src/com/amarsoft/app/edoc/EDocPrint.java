package com.amarsoft.app.edoc;

import java.io.File;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;

public class EDocPrint {
	
	private String objectno;
	private String objecttype;
	private String docNo;
	private String serialNo;
	private String printNum;
	
	public String getObjectno() {
		return objectno;
	}

	public void setObjectno(String objectno) {
		this.objectno = objectno;
	}

	public String getObjecttype() {
		return objecttype;
	}

	public void setObjecttype(String objecttype) {
		this.objecttype = objecttype;
	}

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getPrintNum() {
		return printNum;
	}

	public void setPrintNum(String printNum) {
		this.printNum = printNum;
	}
	
	/**
	 * 获取对应的合同信息
	 * @param tx
	 * @return 合同对象的信息
	 * @throws JBOException 
	 */
	private  List<BizObject> getDocInfo(JBOTransaction tx) throws JBOException{
		//获取模板信息
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_CONFIG");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("edocno =:edocno");
		baq.setParameter("edocno",docNo);
		return baq.getResultList(false);
	}
	
	
	/**
	 * 生成合同对应的doc文件
	 * @param objectno 合同的流水号
	 * @param objecttype 合同的类型
	 * @param docNo 模板编号
	 * @return 生成的文件路径
	 * @throws Exception 
	 */
	private  void getDoc(BizObject aba,JBOTransaction tx) throws Exception{
		
		String docPath = aba.getAttribute("fullpathfmt").getString();
		String xmlPath = aba.getAttribute("fullpathdef").getString();
		
		
		//生成电子合同文件
		//电子合同格式文件存储的服务器的绝对路径地址 <!------待定后改--------->
		Configure CurConfig = Configure.getInstance();
		if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
		String realPrepath = CurConfig.getParameter("WorkDocOfflineSavePath");
		EDocument edoc = new EDocument(realPrepath+docPath,realPrepath+xmlPath);
		
		 String docName = aba.getAttribute("edocname").getString();
		 //定义输出时间
		 Date dateNow = new Date();
		 SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd");
		 String date = sdfTemp.format(dateNow);	 
		 //生成电子合同的服务器的绝对路径 <!--------待定后改---------->
		 String realPrePath = realPrepath;
		 //String realPrePath = "D:";
		 //判断是否有日期文件夹
		 File file = new File(realPrePath+"/"+date);
		 if(!file.exists()){
			 //创建日期文件夹
			 file.mkdir();
		 }
		
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject ci = BusinessObject.createBusinessObject("jbo.app.PUB_EDOC_PRINT");
		//生成打印流水号
		ci.generateKey();
		//获取流水号
		String serialNo = ci.getKeyString();
		
		//存入数据库的合同的相对路径
		 String sOutDocPath = "/"+date+"/"+docName+"-"+serialNo+".doc";
		//文件生成的路径
		 String realPath = realPrePath+sOutDocPath;
		 
		 
		Transaction sqlca = new Transaction("als");
		//生成合同					  
		try{
			HashMap map = new HashMap();
			map.put("SerialNo",objectno);
			map.put("EdocNo",docNo);
			edoc.saveDoc(realPath, map, sqlca);
			sqlca.commit();
		}catch(Exception ex)
		{
			sqlca.rollback();
			
			throw ex;
		}
		finally
		{
			sqlca.disConnect();
		}
		
		//将生成的合同文件信息存入到数据库中,当所要打印合同已存在，则将该合同打印记录删除，再进行新增
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_PRINT");
		tx.join(table);

		BizObjectQuery q = table.createQuery("EdocNo=:EdocNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType")
				.setParameter("EdocNo", aba.getAttribute("EdocNo").toString()).setParameter("ObjectNo", objectno).setParameter("ObjectType", objecttype);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
			for(BizObject bo:DataLast){
					table.createQuery("Delete From O Where SerialNo=:SerialNo").setParameter("SerialNo", bo.getAttribute("SerialNo").getString()).executeUpdate();
			}
		}
		
		ci.setAttributeValue("objectno",objectno);
		ci.setAttributeValue("objecttype",objecttype);
		ci.setAttributeValue("edocno",aba.getAttribute("EdocNo"));
		ci.setAttributeValue("filename",docName);
		ci.setAttributeValue("fullpath",sOutDocPath);
		ci.setAttributeValue("COPYNUM",aba.getAttribute("PAGECOUNT"));
		ci.setAttributeValue("PRINTNUM",0);
		ci.setAttributeValue("InputTime",DateHelper.getBusinessTime());
		bomanager.updateBusinessObject(ci);
		bomanager.updateDB();
}
	

/**
 * 处理doc文档
 * @throws Exception 
 */
public String  docHandle(JBOTransaction tx) throws Exception{
	BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_CONFIG");
	tx.join(bam);
	//查出合同模板信息
	List<BizObject> ba = getDocInfo(tx);
	//生成电子合同并将电子合同信息存入数据库
	for(int i = 0;i < ba.size();i++){
		BizObject aba = ba.get(i);
		getDoc(aba,tx);		
	}
	return "true";
	
} 
/**
 * 打印之后已打印份数+1
 * 
 */
public String upPrintNum(JBOTransaction tx) throws Exception{
	BizObjectManager ci = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_PRINT");
	tx.join(ci);
	int printnum = Integer.parseInt(printNum) + 1 ;
	ci.createQuery("UPDATE O SET PRINTNUM = :PRINTNUM WHERE SERIALNO = :SERIALNO")
	.setParameter("PRINTNUM", printnum)
	.setParameter("SERIALNO", serialNo).executeUpdate();
	return "true";
}
//	public static void main(String[] args) {
//		EDocPrint doc = new EDocPrint();
//		try {
//			doc.getDoc("2014121600000001","jbo.app.BUSINESS_CONTRACT","2014112900000101");
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}
}





