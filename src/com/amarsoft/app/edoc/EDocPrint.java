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
	 * ��ȡ��Ӧ�ĺ�ͬ��Ϣ
	 * @param tx
	 * @return ��ͬ�������Ϣ
	 * @throws JBOException 
	 */
	private  List<BizObject> getDocInfo(JBOTransaction tx) throws JBOException{
		//��ȡģ����Ϣ
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_CONFIG");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("edocno =:edocno");
		baq.setParameter("edocno",docNo);
		return baq.getResultList(false);
	}
	
	
	/**
	 * ���ɺ�ͬ��Ӧ��doc�ļ�
	 * @param objectno ��ͬ����ˮ��
	 * @param objecttype ��ͬ������
	 * @param docNo ģ����
	 * @return ���ɵ��ļ�·��
	 * @throws Exception 
	 */
	private  void getDoc(BizObject aba,JBOTransaction tx) throws Exception{
		
		String docPath = aba.getAttribute("fullpathfmt").getString();
		String xmlPath = aba.getAttribute("fullpathdef").getString();
		
		
		//���ɵ��Ӻ�ͬ�ļ�
		//���Ӻ�ͬ��ʽ�ļ��洢�ķ������ľ���·����ַ <!------�������--------->
		Configure CurConfig = Configure.getInstance();
		if(CurConfig ==null) throw new Exception("��ȡ�����ļ��������������ļ�");
		String realPrepath = CurConfig.getParameter("WorkDocOfflineSavePath");
		EDocument edoc = new EDocument(realPrepath+docPath,realPrepath+xmlPath);
		
		 String docName = aba.getAttribute("edocname").getString();
		 //�������ʱ��
		 Date dateNow = new Date();
		 SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd");
		 String date = sdfTemp.format(dateNow);	 
		 //���ɵ��Ӻ�ͬ�ķ������ľ���·�� <!--------�������---------->
		 String realPrePath = realPrepath;
		 //String realPrePath = "D:";
		 //�ж��Ƿ��������ļ���
		 File file = new File(realPrePath+"/"+date);
		 if(!file.exists()){
			 //���������ļ���
			 file.mkdir();
		 }
		
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject ci = BusinessObject.createBusinessObject("jbo.app.PUB_EDOC_PRINT");
		//���ɴ�ӡ��ˮ��
		ci.generateKey();
		//��ȡ��ˮ��
		String serialNo = ci.getKeyString();
		
		//�������ݿ�ĺ�ͬ�����·��
		 String sOutDocPath = "/"+date+"/"+docName+"-"+serialNo+".doc";
		//�ļ����ɵ�·��
		 String realPath = realPrePath+sOutDocPath;
		 
		 
		Transaction sqlca = new Transaction("als");
		//���ɺ�ͬ					  
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
		
		//�����ɵĺ�ͬ�ļ���Ϣ���뵽���ݿ���,����Ҫ��ӡ��ͬ�Ѵ��ڣ��򽫸ú�ͬ��ӡ��¼ɾ�����ٽ�������
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
 * ����doc�ĵ�
 * @throws Exception 
 */
public String  docHandle(JBOTransaction tx) throws Exception{
	BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_CONFIG");
	tx.join(bam);
	//�����ͬģ����Ϣ
	List<BizObject> ba = getDocInfo(tx);
	//���ɵ��Ӻ�ͬ�������Ӻ�ͬ��Ϣ�������ݿ�
	for(int i = 0;i < ba.size();i++){
		BizObject aba = ba.get(i);
		getDoc(aba,tx);		
	}
	return "true";
	
} 
/**
 * ��ӡ֮���Ѵ�ӡ����+1
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





