


--********************************************************
--		CAT42 - Maiores Geradores
--	 Maior para o Menor - Sobre a coluna de "ST Líquido"
--********************************************************



	SELECT 
		    ROW_NUMBER () OVER (ORDER BY
		    (SUM(C_25_APUR_ValorRessarcimento	) -SUM(C_26_APUR_ValorComplemento		) )
			DESC
			)				
		   
		     AS	ID
			,ID_Parceiro
			,DS_COD_ITEM
			,MAX(DS_DESCR_ITEM)					  AS DS_DESCR_ITEM	
			,SUM(C_25_APUR_ValorRessarcimento	) AS VL_ICMS_ST_RESSAR	
			,SUM(C_26_APUR_ValorComplemento		) AS VL_ICMS_ST_COMPLEMENTAR

			,(SUM(C_25_APUR_ValorRessarcimento	) -SUM(C_26_APUR_ValorComplemento		) )
												  AS VL_ICMS_ST_LIQUIDO_COMPROVADO	
			,SUM(C_27_APUR_ValorICMS			) AS VL_ICMS_PROPRIO_LIQUIDO
			,(SUM(C_25_APUR_ValorRessarcimento)-SUM(C_26_APUR_ValorComplemento))
				 +SUM(C_27_APUR_ValorICMS				 ) AS VL_ICMS_Total_LIQ
		FROM TB_CAT42_Ficha_3 FCH3 WITH(NOLOCK)
	   WHERE
			 FCH3.ID_Parceiro = 411
			 AND
			 FCH3.DT_Periodo BETWEEN '2016.10' AND '2019.08'
			 AND
			 (
			    C_25_APUR_ValorRessarcimento <> 0
				OR
				C_27_APUR_ValorICMS <> 0
				OR
				C_26_APUR_ValorComplemento <> 0
			 )
			   AND
			   EXISTS (
				   SELECT 1
					 FROM TB_CAT42_Produto_LiquidoRessarARQ ARQ WITH(NOLOCK)  
					WHERE
						  ARQ.ID_Parceiro = FCH3.ID_Parceiro
						  AND
						  ARQ.OBS_Liquido = 'Ressarcimento'
						  AND
						  ARQ.COD_ITEM    = FCH3.DS_COD_ITEM
						  AND
						  ARQ.DT_PeriodoLimite <= FCH3.DT_Periodo
			   )
			   AND
			   DS_COD_ITEM	 NOT IN (
			   '005901510002'
			   )
	   GROUP BY 
			 ID_Parceiro
			,DS_COD_ITEM	


--********************************************************
--		CAT17 - 10 Maiores Geradores
--	 
--********************************************************

	   SELECT
		      CASE
				  WHEN CTR.ID_Parceiro = 2 THEN NULL
				  ELSE CONVERT(VARCHAR(8),CTR.ID_Parceiro) END			 AS Parceiro
			 ,CTR.DT_Periodo											 AS DT_Periodo
			 ,CTR.ID_CodigoProduto										 AS ID_CodigoProduto
		     ,CTR.DS_Descricao											 AS DS_Descricao
			 ,CTR.DS_CstIcms											 AS CstIcms
			 ,CTR.ID_CFOP												 AS CFOP
			 ,CTR.NR_Item												 AS Item
			 ,CTR.NR_ChaveNFe											 AS ChaveNFe
			 ,REPLACE(ISNULL(CTR.C_04_ENT_Quantidade		,0),'.',',') AS Quantidade
			 ,REPLACE(ISNULL(CTR.VL_ValorProduto			,0),'.',',') AS ValorProduto
			 ,REPLACE(ISNULL(CTR.C_05_ENT_ValorBaseRetencao ,0),'.',',') AS ValorBaseST
		 FROM
			  TB_CAT17_Centralizador CTR WITH(NOLOCK)
		WHERE
			  CTR.ID_Parceiro	     = 411
			  AND				     
			  CTR.DT_Periodo	     BETWEEN '2016.10' AND '2018.12'
		      AND					 
			  CTR.DS_Estouro		 = 'OK'
			  AND
			  CTR.DS_VerifDocumental = 'SIM'
			  AND
			  CTR.IND_SaldoESD	     = 'Entradas'
			  AND
			  CTR.ID_CodigoProduto  IN (
						 '006201780002'
						,'006201780035'
						,'006800200004'
						,'030000210010'
						,'028701180002'
						,'006201780003'
						,'030000210007'
						,'006202290002'
						,'006800200007'
						,'015900030050'
			  )
		      AND
			  SUBSTRING(CTR.DS_CstIcms,2,2) = '10'
			  AND
			  CTR.ID_CFOP NOT LIKE '_.949'
		ORDER BY
		      ID_CodigoProduto
			 ,ID