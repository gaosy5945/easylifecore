package com.amarsoft.app.als.awe.ow.processor.impl.html.bodyhtml;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Hashtable;

import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.datamodel.CatalogModel;
import com.amarsoft.awe.dw.ui.page.GenHtmlImp;
import com.amarsoft.awe.dw.ui.page.body.GenBodyData;
import com.amarsoft.awe.dw.ui.page.body.GenBodyDataImp1;
import com.amarsoft.awe.dw.ui.page.body.GenBodyDataImp2;
import com.amarsoft.awe.dw.ui.style.data.PageStyleData;
import com.amarsoft.dict.als.cache.AWEDataWindowCache;

public class DefaultPageHTMLGenerator extends GenHtmlImp {
	private GenBodyData body;

	private GenBodyData getBodyHTMLGenerator(int editStatus) throws Exception {
		int iColCount = 0;
		if ((groupinfo[9] == null) || (groupinfo[9].equals(""))
				|| (groupinfo[9].equals("0"))) {
			CatalogModel obj = AWEDataWindowCache.getInstance()
					.getCatalogModel(asObj.getDONO());
			if ((obj == null) || (obj.getColCount() == null)
					|| (obj.getColCount().equals("0"))) {
				iColCount = 1;
			} else
				iColCount = Integer.parseInt(obj.getColCount());
		} else {
			iColCount = Integer.parseInt(groupinfo[9]);
			if (iColCount == 0)
				iColCount = 1;
		}
		String sGroupBody = "";

		if ((iColCount == 1)) {
			sGroupBody = groupinfo[6];
			if ((sGroupBody == null) || (sGroupBody.equals("")))
				sGroupBody = pageStyleData.groupBody1;
		} else if (iColCount == 2) {
			sGroupBody = groupinfo[7];
			if ((sGroupBody == null) || (sGroupBody.equals("")))
				sGroupBody = pageStyleData.groupBody2;
		} else {
			sGroupBody = pageStyleData.groupBody1;
		}
		if ((pageStyleData.groupBodyParser == null)|| (pageStyleData.groupBodyParser.length() == 0)) {
			if (iColCount == 1) {
				body = new BodyHTMLGenerator1(this.asObj, datas, sGroupBody);
				body.setEditstatus(editStatus);
			} else if (iColCount == 2) {
				body = new BodyHTMLGenerator2(this.asObj, datas, sGroupBody);
				body.setEditstatus(editStatus);
			}
		} else {
			Class clz = Class.forName(pageStyleData.groupBodyParser);
			Constructor c = clz.getConstructor(new Class[] {
					ASDataObject.class, ArrayList.class, String.class });
			body = ((GenBodyData) c.newInstance(new Object[] { this.asObj,
					datas, sGroupBody }));

			body.setEditstatus(editStatus);
		}

		this.groupOut[1] = sGroupBody;

		for (int i = 0; i < groupinfo.length; i++) {
			if (groupinfo[i] == null)
				groupinfo[i] = "";
		}
		this.groupinfo = groupinfo;
		return body;
	}

	public DefaultPageHTMLGenerator(ASDataObject asObj, ArrayList datas,PageStyleData pageStyleData, String[] groupinfo, int editStatus,
			String webRootPath) throws Exception {
		super(asObj, datas, pageStyleData, groupinfo, editStatus, webRootPath);
		this.body=getBodyHTMLGenerator(editStatus);
	}

	public String gen(Hashtable values) throws Exception {
		String sHead = getGroupHead();
		this.groupOut[0] = sHead;
		String sBody = this.body.getGroupBody(values, this.webRootPath);
		String sFoot = getGroupFoot();
		this.groupOut[2] = sFoot;
		return sHead + sBody + sFoot;
	}
}
