// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OW2ShaderMetallic"
{
	Properties
	{
		[NoScaleOffset][Header(__________OW2 Shader by DarkBlade909 v0.1 (WIP)__________)][Space(5)]_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset]_PBR("PBR", 2D) = "gray" {}
		[NoScaleOffset][Normal]_BumpMap("Normal Map", 2D) = "white" {}
		[NoScaleOffset]_Emission("Emission Map", 2D) = "black" {}
		_EmissionStrength("Emission Strength", Float) = 1
		[NoScaleOffset]_Opacity("Opacity Map", 2D) = "white" {}
		[NoScaleOffset]_DetailMask("Detail Mask", 2D) = "white" {}
		[SingleLineTexture][Space(5)][Header(____________________Detail Maps____________________)][Space(20)]_DetailMapBlack("Detail Map Black", 2D) = "white" {}
		_DetailMapBlackScaleSkew("Detail Map Black Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapRed("Detail Map Red", 2D) = "white" {}
		_DetailMapRedScaleSkew("Detail Map Red Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapGreen("Detail Map Green", 2D) = "white" {}
		_DetailMapGreenScaleSkew("Detail Map Green Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapBlue("Detail Map Blue", 2D) = "white" {}
		_DetailMapBlueScaleSkew("Detail Map Blue Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapYellow("Detail Map Yellow", 2D) = "white" {}
		_DetailMapYellowScaleSkew("Detail Map Yellow Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapCyan("Detail Map Cyan", 2D) = "white" {}
		_DetailMapCyanScaleSkew("Detail Map Cyan Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapPink("Detail Map Pink", 2D) = "white" {}
		_DetailMapPinkScaleSkew("Detail Map Pink Scale/Skew", Vector) = (1,1,0,0)
		[SingleLineTexture]_DetailMapWhite("Detail Map White", 2D) = "white" {}
		_DetailMapWhiteScaleSkew("Detail Map White Scale/Skew", Vector) = (1,1,0,0)
		_DetailGlossStrength("Detail Gloss Strength", Float) = 0.25
		_DetailNormalStrength("Detail Normal Strength", Float) = 0.25
		_DetailAO("DetailAO", Float) = 1
		_Glossiness("Glossiness", Range( 0 , 1)) = 0
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel", Float) = 0
		_CutoutClipping("Cutout Clipping", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FRESNEL_ON
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapWhite);
		uniform float4 _DetailMapWhiteScaleSkew;
		SamplerState sampler_linear_repeat;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMask);
		SamplerState sampler_DetailMask;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapBlack);
		uniform float4 _DetailMapBlackScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapRed);
		uniform float4 _DetailMapRedScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapYellow);
		uniform float4 _DetailMapYellowScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapGreen);
		uniform float4 _DetailMapGreenScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapCyan);
		uniform float4 _DetailMapCyanScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapBlue);
		uniform float4 _DetailMapBlueScaleSkew;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMapPink);
		uniform float4 _DetailMapPinkScaleSkew;
		uniform float _DetailNormalStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Emission);
		uniform float _EmissionStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_PBR);
		uniform float _DetailGlossStrength;
		uniform float _Glossiness;
		uniform float _DetailAO;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Opacity);
		uniform float _CutoutClipping;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 _Center = float2(0.5,0.5);
			float2 temp_output_3_0_g145 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g145 = (float2(_DetailMapWhiteScaleSkew.w , _DetailMapWhiteScaleSkew.z));
			float2 break20_g145 = ( temp_output_3_0_g145 * appendResult16_g145 );
			float2 appendResult14_g145 = (float2(_DetailMapWhiteScaleSkew.x , _DetailMapWhiteScaleSkew.y));
			float2 break19_g145 = ( appendResult14_g145 * temp_output_3_0_g145 );
			float2 appendResult23_g145 = (float2(( break20_g145.y + break19_g145.x ) , ( break20_g145.x + break19_g145.y )));
			float4 temp_output_2_0_g160 = SAMPLE_TEXTURE2D( _DetailMapWhite, sampler_linear_repeat, ( appendResult23_g145 + _Center ) );
			float4 temp_cast_0 = (1.0).xxxx;
			float2 uv_DetailMask28 = i.uv_texcoord;
			float4 tex2DNode28 = SAMPLE_TEXTURE2D( _DetailMask, sampler_DetailMask, uv_DetailMask28 );
			float4 break10_g169 = tex2DNode28;
			float temp_output_11_0_g169 = ( break10_g169.r + break10_g169.g + break10_g169.b );
			float clampResult37_g169 = clamp( step( 2.5 , temp_output_11_0_g169 ) , 0.0 , 1.0 );
			float temp_output_116_7_g160 = ( clampResult37_g169 * break10_g169.a );
			float2 lerpResult64_g160 = lerp( float2( 0,0 ) , (( ( temp_output_2_0_g160 * 2.0 ) - temp_cast_0 )).rg , temp_output_116_7_g160);
			float2 temp_output_3_0_g148 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g148 = (float2(_DetailMapBlackScaleSkew.w , _DetailMapBlackScaleSkew.z));
			float2 break20_g148 = ( temp_output_3_0_g148 * appendResult16_g148 );
			float2 appendResult14_g148 = (float2(_DetailMapBlackScaleSkew.x , _DetailMapBlackScaleSkew.y));
			float2 break19_g148 = ( appendResult14_g148 * temp_output_3_0_g148 );
			float2 appendResult23_g148 = (float2(( break20_g148.y + break19_g148.x ) , ( break20_g148.x + break19_g148.y )));
			float4 temp_output_3_0_g160 = SAMPLE_TEXTURE2D( _DetailMapBlack, sampler_linear_repeat, ( appendResult23_g148 + _Center ) );
			float4 temp_cast_1 = (1.0).xxxx;
			float clampResult36_g169 = clamp( step( temp_output_11_0_g169 , 0.5 ) , 0.0 , 1.0 );
			float temp_output_116_6_g160 = ( clampResult36_g169 * break10_g169.a );
			float2 lerpResult65_g160 = lerp( float2( 0,0 ) , (( ( temp_output_3_0_g160 * 2.0 ) - temp_cast_1 )).rg , temp_output_116_6_g160);
			float2 temp_output_3_0_g138 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g138 = (float2(_DetailMapRedScaleSkew.w , _DetailMapRedScaleSkew.z));
			float2 break20_g138 = ( temp_output_3_0_g138 * appendResult16_g138 );
			float2 appendResult14_g138 = (float2(_DetailMapRedScaleSkew.x , _DetailMapRedScaleSkew.y));
			float2 break19_g138 = ( appendResult14_g138 * temp_output_3_0_g138 );
			float2 appendResult23_g138 = (float2(( break20_g138.y + break19_g138.x ) , ( break20_g138.x + break19_g138.y )));
			float4 temp_output_4_0_g160 = SAMPLE_TEXTURE2D( _DetailMapRed, sampler_linear_repeat, ( appendResult23_g138 + _Center ) );
			float4 temp_cast_2 = (1.0).xxxx;
			float clampResult35_g169 = clamp( ( ( break10_g169.r - break10_g169.g ) - break10_g169.b ) , 0.0 , 1.0 );
			float temp_output_116_0_g160 = ( clampResult35_g169 * break10_g169.a );
			float2 lerpResult66_g160 = lerp( float2( 0,0 ) , (( ( temp_output_4_0_g160 * 2.0 ) - temp_cast_2 )).rg , temp_output_116_0_g160);
			float2 temp_output_3_0_g144 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g144 = (float2(_DetailMapYellowScaleSkew.w , _DetailMapYellowScaleSkew.z));
			float2 break20_g144 = ( temp_output_3_0_g144 * appendResult16_g144 );
			float2 appendResult14_g144 = (float2(_DetailMapYellowScaleSkew.x , _DetailMapYellowScaleSkew.y));
			float2 break19_g144 = ( appendResult14_g144 * temp_output_3_0_g144 );
			float2 appendResult23_g144 = (float2(( break20_g144.y + break19_g144.x ) , ( break20_g144.x + break19_g144.y )));
			float4 temp_output_5_0_g160 = SAMPLE_TEXTURE2D( _DetailMapYellow, sampler_linear_repeat, ( appendResult23_g144 + _Center ) );
			float4 temp_cast_3 = (1.0).xxxx;
			float clampResult40_g169 = clamp( step( 1.75 , ( ( break10_g169.r + break10_g169.g ) - break10_g169.b ) ) , 0.0 , 1.0 );
			float temp_output_116_1_g160 = ( clampResult40_g169 * break10_g169.a );
			float2 lerpResult67_g160 = lerp( float2( 0,0 ) , (( ( temp_output_5_0_g160 * 2.0 ) - temp_cast_3 )).rg , temp_output_116_1_g160);
			float2 temp_output_3_0_g147 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g147 = (float2(_DetailMapGreenScaleSkew.w , _DetailMapGreenScaleSkew.z));
			float2 break20_g147 = ( temp_output_3_0_g147 * appendResult16_g147 );
			float2 appendResult14_g147 = (float2(_DetailMapGreenScaleSkew.x , _DetailMapGreenScaleSkew.y));
			float2 break19_g147 = ( appendResult14_g147 * temp_output_3_0_g147 );
			float2 appendResult23_g147 = (float2(( break20_g147.y + break19_g147.x ) , ( break20_g147.x + break19_g147.y )));
			float4 temp_output_6_0_g160 = SAMPLE_TEXTURE2D( _DetailMapGreen, sampler_linear_repeat, ( appendResult23_g147 + _Center ) );
			float4 temp_cast_4 = (1.0).xxxx;
			float clampResult38_g169 = clamp( ( ( break10_g169.g - break10_g169.b ) - break10_g169.r ) , 0.0 , 1.0 );
			float temp_output_116_2_g160 = ( clampResult38_g169 * break10_g169.a );
			float2 lerpResult68_g160 = lerp( float2( 0,0 ) , (( ( temp_output_6_0_g160 * 2.0 ) - temp_cast_4 )).rg , temp_output_116_2_g160);
			float2 temp_output_3_0_g143 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g143 = (float2(_DetailMapCyanScaleSkew.w , _DetailMapCyanScaleSkew.z));
			float2 break20_g143 = ( temp_output_3_0_g143 * appendResult16_g143 );
			float2 appendResult14_g143 = (float2(_DetailMapCyanScaleSkew.x , _DetailMapCyanScaleSkew.y));
			float2 break19_g143 = ( appendResult14_g143 * temp_output_3_0_g143 );
			float2 appendResult23_g143 = (float2(( break20_g143.y + break19_g143.x ) , ( break20_g143.x + break19_g143.y )));
			float4 temp_output_7_0_g160 = SAMPLE_TEXTURE2D( _DetailMapCyan, sampler_linear_repeat, ( appendResult23_g143 + _Center ) );
			float4 temp_cast_5 = (1.0).xxxx;
			float clampResult41_g169 = clamp( step( 1.75 , ( ( break10_g169.r + break10_g169.b ) - break10_g169.g ) ) , 0.0 , 1.0 );
			float temp_output_116_3_g160 = ( clampResult41_g169 * break10_g169.a );
			float2 lerpResult69_g160 = lerp( float2( 0,0 ) , (( ( temp_output_7_0_g160 * 2.0 ) - temp_cast_5 )).rg , temp_output_116_3_g160);
			float2 temp_output_3_0_g149 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g149 = (float2(_DetailMapBlueScaleSkew.w , _DetailMapBlueScaleSkew.z));
			float2 break20_g149 = ( temp_output_3_0_g149 * appendResult16_g149 );
			float2 appendResult14_g149 = (float2(_DetailMapBlueScaleSkew.x , _DetailMapBlueScaleSkew.y));
			float2 break19_g149 = ( appendResult14_g149 * temp_output_3_0_g149 );
			float2 appendResult23_g149 = (float2(( break20_g149.y + break19_g149.x ) , ( break20_g149.x + break19_g149.y )));
			float4 temp_output_8_0_g160 = SAMPLE_TEXTURE2D( _DetailMapBlue, sampler_linear_repeat, ( appendResult23_g149 + _Center ) );
			float4 temp_cast_6 = (1.0).xxxx;
			float clampResult39_g169 = clamp( ( ( break10_g169.b - break10_g169.r ) - break10_g169.g ) , 0.0 , 1.0 );
			float temp_output_116_4_g160 = ( clampResult39_g169 * break10_g169.a );
			float2 lerpResult70_g160 = lerp( float2( 0,0 ) , (( ( temp_output_8_0_g160 * 2.0 ) - temp_cast_6 )).rg , temp_output_116_4_g160);
			float2 temp_output_3_0_g146 = ( i.uv_texcoord - _Center );
			float2 appendResult16_g146 = (float2(_DetailMapPinkScaleSkew.w , _DetailMapPinkScaleSkew.z));
			float2 break20_g146 = ( temp_output_3_0_g146 * appendResult16_g146 );
			float2 appendResult14_g146 = (float2(_DetailMapPinkScaleSkew.x , _DetailMapPinkScaleSkew.y));
			float2 break19_g146 = ( appendResult14_g146 * temp_output_3_0_g146 );
			float2 appendResult23_g146 = (float2(( break20_g146.y + break19_g146.x ) , ( break20_g146.x + break19_g146.y )));
			float4 temp_output_40_0_g160 = SAMPLE_TEXTURE2D( _DetailMapPink, sampler_linear_repeat, ( appendResult23_g146 + _Center ) );
			float4 temp_cast_7 = (1.0).xxxx;
			float clampResult42_g169 = clamp( step( 1.75 , ( ( break10_g169.g + break10_g169.b ) - break10_g169.r ) ) , 0.0 , 1.0 );
			float temp_output_116_5_g160 = ( clampResult42_g169 * break10_g169.a );
			float2 lerpResult71_g160 = lerp( float2( 0,0 ) , (( ( temp_output_40_0_g160 * 2.0 ) - temp_cast_7 )).rg , temp_output_116_5_g160);
			float2 lerpResult119 = lerp( float2( 0,0 ) , ( lerpResult64_g160 + lerpResult65_g160 + lerpResult66_g160 + lerpResult67_g160 + lerpResult68_g160 + lerpResult69_g160 + lerpResult70_g160 + lerpResult71_g160 ) , _DetailNormalStrength);
			float2 uv_BumpMap8 = i.uv_texcoord;
			float3 NormalMap9 = UnpackNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_linear_repeat, uv_BumpMap8 ) );
			float3 appendResult139 = (float3(( lerpResult119 + (NormalMap9).xy ) , 1.0));
			float3 finalNormal109 = appendResult139;
			o.Normal = finalNormal109;
			float2 uv_MainTex1 = i.uv_texcoord;
			float4 tex2DNode1 = SAMPLE_TEXTURE2D( _MainTex, sampler_linear_repeat, uv_MainTex1 );
			float4 Albedo3 = tex2DNode1;
			o.Albedo = Albedo3.rgb;
			float2 uv_Emission23 = i.uv_texcoord;
			float4 finalEmission24 = ( SAMPLE_TEXTURE2D( _Emission, sampler_linear_repeat, uv_Emission23 ) * Albedo3 * _EmissionStrength );
			o.Emission = finalEmission24.rgb;
			float2 uv_PBR5 = i.uv_texcoord;
			float4 tex2DNode5 = SAMPLE_TEXTURE2D( _PBR, sampler_linear_repeat, uv_PBR5 );
			float clampResult180 = clamp( ( ( ( step( 0.525 , tex2DNode5.r ) * tex2DNode5.r ) - 0.5 ) * 2.0 ) , 0.0 , 1.0 );
			float Metallic6 = clampResult180;
			o.Metallic = Metallic6;
			float Gloss7 = tex2DNode5.g;
			float clampResult55_g160 = clamp( ( temp_output_116_7_g160 * (temp_output_2_0_g160).a ) , 0.0 , 1.0 );
			float clampResult56_g160 = clamp( ( temp_output_116_6_g160 * (temp_output_3_0_g160).a ) , 0.0 , 1.0 );
			float clampResult57_g160 = clamp( ( temp_output_116_0_g160 * (temp_output_4_0_g160).a ) , 0.0 , 1.0 );
			float clampResult58_g160 = clamp( ( temp_output_116_1_g160 * (temp_output_5_0_g160).a ) , 0.0 , 1.0 );
			float clampResult59_g160 = clamp( ( temp_output_116_2_g160 * (temp_output_6_0_g160).a ) , 0.0 , 1.0 );
			float clampResult60_g160 = clamp( ( temp_output_116_3_g160 * (temp_output_7_0_g160).a ) , 0.0 , 1.0 );
			float clampResult61_g160 = clamp( ( temp_output_116_4_g160 * (temp_output_8_0_g160).a ) , 0.0 , 1.0 );
			float clampResult62_g160 = clamp( ( temp_output_116_5_g160 * (temp_output_40_0_g160).a ) , 0.0 , 1.0 );
			float clampResult53_g160 = clamp( ( clampResult55_g160 + clampResult56_g160 + clampResult57_g160 + clampResult58_g160 + clampResult59_g160 + clampResult60_g160 + clampResult61_g160 + clampResult62_g160 ) , 0.0 , 1.0 );
			float lerpResult108 = lerp( Gloss7 , clampResult53_g160 , _DetailGlossStrength);
			float lerpResult206 = lerp( ( _Glossiness * 0.99 ) , lerpResult108 , Metallic6);
			float temp_output_192_0 = pow( lerpResult108 , ( 1.0 - lerpResult206 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV195 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode195 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV195, 1.0 ) );
			#ifdef _FRESNEL_ON
				float staticSwitch200 = temp_output_192_0;
			#else
				float staticSwitch200 = ( temp_output_192_0 - ( fresnelNode195 * 0.5 ) );
			#endif
			float clampResult197 = clamp( staticSwitch200 , 0.0 , 1.0 );
			float finalGloss106 = clampResult197;
			o.Smoothness = finalGloss106;
			float3 temp_cast_11 = (tex2DNode1.a).xxx;
			float3 temp_cast_12 = (tex2DNode1.a).xxx;
			float3 gammaToLinear2 = GammaToLinearSpace( temp_cast_12 );
			float DetailAO181 = ( ( temp_output_116_7_g160 * (temp_output_2_0_g160).b ) + ( temp_output_116_6_g160 * (temp_output_3_0_g160).b ) + ( temp_output_116_0_g160 * (temp_output_4_0_g160).b ) + ( temp_output_116_1_g160 * (temp_output_5_0_g160).b ) + ( temp_output_116_2_g160 * (temp_output_6_0_g160).b ) + ( temp_output_116_3_g160 * (temp_output_7_0_g160).b ) + ( temp_output_116_4_g160 * (temp_output_8_0_g160).b ) + ( temp_output_116_5_g160 * (temp_output_40_0_g160).b ) );
			float clampResult188 = clamp( DetailAO181 , 0.0 , 1.0 );
			float lerpResult186 = lerp( 1.0 , clampResult188 , _DetailAO);
			float3 AO4 = ( gammaToLinear2 * lerpResult186 );
			o.Occlusion = AO4.x;
			o.Alpha = 1;
			float2 uv_Opacity239 = i.uv_texcoord;
			float4 Opacity240 = SAMPLE_TEXTURE2D( _Opacity, sampler_linear_repeat, uv_Opacity239 );
			clip( Opacity240.r - _CutoutClipping );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;664;1425;375;3823.411;409.8608;2.06213;True;False
Node;AmplifyShaderEditor.SamplerStateNode;243;-2637.234,-262.2647;Inherit;False;0;0;0;1;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.WireNode;255;-2405.549,-408.3739;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;5;-2269.452,-586.1541;Inherit;True;Property;_PBR;PBR;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;568d5ed4feaf5a84499a0f3b4b28c108;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;173;-1924.836,-641.9594;Inherit;False;2;0;FLOAT;0.525;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-1789.742,-581.126;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;222;-2817.152,782.2961;Inherit;False;Property;_DetailMapWhiteScaleSkew;Detail Map White Scale/Skew;22;0;Create;True;0;0;0;False;0;False;1,1,0,0;346.41,346.41,-200,200;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;230;-2818.279,1989.973;Inherit;False;Property;_DetailMapBlueScaleSkew;Detail Map Blue Scale/Skew;14;0;Create;True;0;0;0;False;0;False;1,1,0,0;35,35,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;220;-2819.246,979.3709;Inherit;False;Property;_DetailMapBlackScaleSkew;Detail Map Black Scale/Skew;8;0;Create;True;0;0;0;False;0;False;1,1,0,0;20,20,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;224;-2818.515,1386.759;Inherit;False;Property;_DetailMapYellowScaleSkew;Detail Map Yellow Scale/Skew;16;0;Create;True;0;0;0;False;0;False;1,1,0,0;212,212,-212,212;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;217;-2816.227,1192.29;Inherit;False;Property;_DetailMapRedScaleSkew;Detail Map Red Scale/Skew;10;0;Create;True;0;0;0;False;0;False;1,1,0,0;43.301,43.301,-25,25;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;232;-2818.279,2183.398;Inherit;False;Property;_DetailMapPinkScaleSkew;Detail Map Pink Scale/Skew;20;0;Create;True;0;0;0;False;0;False;1,1,0,0;57.9555,57.9555,-15.5291,15.5291;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;228;-2818.28,1785.601;Inherit;False;Property;_DetailMapCyanScaleSkew;Detail Map Cyan Scale/Skew;18;0;Create;True;0;0;0;False;0;False;1,1,0,0;50,50,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerStateNode;245;-3099.347,1491.769;Inherit;False;0;0;0;1;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;175;-1661.742,-584.126;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;226;-2818.714,1582.909;Inherit;False;Property;_DetailMapGreenScaleSkew;Detail Map Green Scale/Skew;12;0;Create;True;0;0;0;False;0;False;1,1,0,0;80,80,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;219;-2517.508,984.4539;Inherit;False;OW2ScaleUV;-1;;148;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;221;-2515.414,787.3791;Inherit;False;OW2ScaleUV;-1;;145;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;247;-2838.772,1779.814;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.FunctionNode;212;-2514.489,1197.373;Inherit;False;OW2ScaleUV;-1;;138;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;225;-2516.977,1587.992;Inherit;False;OW2ScaleUV;-1;;147;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;253;-2907.54,2117.358;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.FunctionNode;223;-2516.777,1391.842;Inherit;False;OW2ScaleUV;-1;;144;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-1519.741,-585.126;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;231;-2516.542,2188.481;Inherit;False;OW2ScaleUV;-1;;146;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;246;-2889.744,1959.231;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.FunctionNode;227;-2516.543,1790.684;Inherit;False;OW2ScaleUV;-1;;143;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;251;-2831.906,1293.688;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.WireNode;252;-2839.238,1461.239;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.FunctionNode;229;-2516.542,1995.056;Inherit;False;OW2ScaleUV;-1;;149;fdfb8c8f91f3f9945968266131acc402;0;5;1;FLOAT2;0,0;False;8;FLOAT;1;False;11;FLOAT;1;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;250;-2837.835,1126.072;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.WireNode;248;-2836.733,1598.358;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.WireNode;249;-2869.252,938.1905;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;104;-2217.705,2156.918;Inherit;True;Property;_DetailMapPink;Detail Map Pink;19;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;4b8309014e0269747b7ec00caab15a7f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;95;-2222.348,952.2244;Inherit;True;Property;_DetailMapBlack;Detail Map Black;7;1;[SingleLineTexture];Create;True;0;0;0;False;3;Space(5);Header(____________________Detail Maps____________________);Space(20);False;-1;None;5966e434216464440951c91d4ec148a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-2215.873,2348.398;Inherit;True;Property;_DetailMask;Detail Mask;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;605855d3fc4db84458e1b207002e89ea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-2221.293,1758.598;Inherit;True;Property;_DetailMapCyan;Detail Map Cyan;17;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;248693a65d9edb14faed977fdcc679d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-2218.498,1559.437;Inherit;True;Property;_DetailMapGreen;Detail Map Green;11;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;e610c4ba432b0724aaa5f9175d72bcb6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;100;-2217.705,1363.866;Inherit;True;Property;_DetailMapYellow;Detail Map Yellow;15;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;2624e33569d01a6488de1bb78953d262;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;180;-1392.07,-583.689;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-2219.501,1963.141;Inherit;True;Property;_DetailMapBlue;Detail Map Blue;13;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;bace7f987aeb18b4d82d8649f05af5ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-2217.219,755.3985;Inherit;True;Property;_DetailMapWhite;Detail Map White;21;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;3affd9a4c08e6034a9dd85a7cd947a82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-2221.293,1168.293;Inherit;True;Property;_DetailMapRed;Detail Map Red;9;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;1c1277a4800d31f44af2913467320e1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1931.976,-475.7797;Inherit;False;Gloss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;242;-1647.16,1541.232;Inherit;False;Detail Map;-1;;160;88a72c672b8fdc44ba4ddaf306e7d091;0;9;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;40;COLOR;0,0,0,0;False;11;COLOR;0,0,0,0;False;3;FLOAT;113;FLOAT2;0;FLOAT;43
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1525.029,1447.033;Inherit;False;7;Gloss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;257;-2384.489,93.42149;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1250.343,-585.4558;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-1233.422,1655.662;Inherit;False;Property;_Glossiness;Glossiness;26;0;Create;True;0;0;0;False;0;False;0;0.343;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1513.718,1355.534;Inherit;False;Property;_DetailGlossStrength;Detail Gloss Strength;23;0;Create;True;0;0;0;False;0;False;0.25;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-1014.342,1496.415;Inherit;False;6;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-962.422,1656.662;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;108;-1209.14,1532.303;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-2269.682,94.31586;Inherit;True;Property;_BumpMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;False;0;0;0;False;0;False;-1;None;2bde42c534247ae4093742eebdc2626c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnpackScaleNormalNode;96;-1953.813,99.21317;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;206;-816.9971,1696.266;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;193;-673.4224,1636.662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;195;-368.1772,1684.854;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-1200.639,1415.386;Inherit;False;DetailAO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1718.796,93.13878;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1526.397,1813.183;Inherit;False;Property;_DetailNormalStrength;Detail Normal Strength;24;0;Create;True;0;0;0;False;0;False;0.25;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1473.481,1905.352;Inherit;False;9;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-2309.813,-123.6177;Inherit;False;181;DetailAO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-119.1772,1687.854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;192;-551.3467,1541.362;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2272.541,-327.8032;Inherit;True;Property;_MainTex;Albedo;0;1;[NoScaleOffset];Create;False;0;0;0;False;2;Header(__________OW2 Shader by DarkBlade909 v0.1 (WIP)__________);Space(5);False;-1;None;9e023c9660f0bda4c9aeb314ae6552c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;119;-1234.716,1724.701;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-2148.836,-13.68161;Inherit;False;Property;_DetailAO;DetailAO;25;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-1965.957,-330.113;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;196;64.32288,1550.854;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;137;-1268.301,1890.874;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;256;-2435.089,214.4213;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.ClampOpNode;188;-2138.643,-126.6089;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1006.495,1830.575;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;23;-2268.995,297.8804;Inherit;True;Property;_Emission;Emission Map;3;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;1fd00da85908b50439cfe388c8ace93d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2144.995,486.8806;Inherit;False;3;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GammaToLinearNode;2;-1966.686,-209.8041;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;200;225.5229,1548.254;Inherit;False;Property;_Fresnel;Fresnel;27;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-2180.907,567.8178;Inherit;False;Property;_EmissionStrength;Emission Strength;4;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;254;-2445.549,-668.3737;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.LerpOp;186;-1944.813,-104.6177;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;197;430.6229,1552.954;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1755.813,-178.6177;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;139;-883.9377,1829.765;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1892.995,371.8804;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;239;-2266.314,-848.8932;Inherit;True;Property;_Opacity;Opacity Map;5;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-751.2413,1827.32;Inherit;False;finalNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1613.922,-178.6071;Inherit;False;AO;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;584.983,1551.642;Inherit;False;finalGloss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-1947.688,-849.4308;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1763.133,369.7633;Inherit;False;finalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-374.0381,201.8417;Inherit;False;4;AO;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-373.0381,46.84174;Inherit;False;6;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-373.6963,273.9211;Inherit;False;240;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-375.9253,-274.4945;Inherit;False;207;DetailMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-394.3262,-29.71359;Inherit;False;24;finalEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-377.9255,-192.0435;Inherit;False;3;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-387.6724,348.4283;Inherit;False;Property;_CutoutClipping;Cutout Clipping;28;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-1788.85,2346.439;Inherit;False;DetailMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-387.2331,-111.8283;Inherit;False;109;finalNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-375.0381,124.8417;Inherit;False;106;finalGloss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-71.35329,-45.12774;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;OW2ShaderMetallic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;237;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;255;0;243;0
WireConnection;5;7;255;0
WireConnection;173;1;5;1
WireConnection;174;0;173;0
WireConnection;174;1;5;1
WireConnection;175;0;174;0
WireConnection;219;8;220;1
WireConnection;219;11;220;2
WireConnection;219;12;220;3
WireConnection;219;13;220;4
WireConnection;221;8;222;1
WireConnection;221;11;222;2
WireConnection;221;12;222;3
WireConnection;221;13;222;4
WireConnection;247;0;245;0
WireConnection;212;8;217;1
WireConnection;212;11;217;2
WireConnection;212;12;217;3
WireConnection;212;13;217;4
WireConnection;225;8;226;1
WireConnection;225;11;226;2
WireConnection;225;12;226;3
WireConnection;225;13;226;4
WireConnection;253;0;245;0
WireConnection;223;8;224;1
WireConnection;223;11;224;2
WireConnection;223;12;224;3
WireConnection;223;13;224;4
WireConnection;176;0;175;0
WireConnection;231;8;232;1
WireConnection;231;11;232;2
WireConnection;231;12;232;3
WireConnection;231;13;232;4
WireConnection;246;0;245;0
WireConnection;227;8;228;1
WireConnection;227;11;228;2
WireConnection;227;12;228;3
WireConnection;227;13;228;4
WireConnection;251;0;245;0
WireConnection;252;0;245;0
WireConnection;229;8;230;1
WireConnection;229;11;230;2
WireConnection;229;12;230;3
WireConnection;229;13;230;4
WireConnection;250;0;245;0
WireConnection;248;0;245;0
WireConnection;249;0;245;0
WireConnection;104;1;231;0
WireConnection;104;7;253;0
WireConnection;95;1;219;0
WireConnection;95;7;250;0
WireConnection;102;1;227;0
WireConnection;102;7;247;0
WireConnection;101;1;225;0
WireConnection;101;7;248;0
WireConnection;100;1;223;0
WireConnection;100;7;252;0
WireConnection;180;0;176;0
WireConnection;103;1;229;0
WireConnection;103;7;246;0
WireConnection;98;1;221;0
WireConnection;98;7;249;0
WireConnection;99;1;212;0
WireConnection;99;7;251;0
WireConnection;7;0;5;2
WireConnection;242;2;98;0
WireConnection;242;3;95;0
WireConnection;242;4;99;0
WireConnection;242;5;100;0
WireConnection;242;6;101;0
WireConnection;242;7;102;0
WireConnection;242;8;103;0
WireConnection;242;40;104;0
WireConnection;242;11;28;0
WireConnection;257;0;243;0
WireConnection;6;0;180;0
WireConnection;194;0;190;0
WireConnection;108;0;105;0
WireConnection;108;1;242;43
WireConnection;108;2;112;0
WireConnection;8;7;257;0
WireConnection;96;0;8;0
WireConnection;206;0;194;0
WireConnection;206;1;108;0
WireConnection;206;2;204;0
WireConnection;193;0;206;0
WireConnection;181;0;242;113
WireConnection;9;0;96;0
WireConnection;202;0;195;0
WireConnection;192;0;108;0
WireConnection;192;1;193;0
WireConnection;1;7;243;0
WireConnection;119;1;242;0
WireConnection;119;2;120;0
WireConnection;3;0;1;0
WireConnection;196;0;192;0
WireConnection;196;1;202;0
WireConnection;137;0;111;0
WireConnection;256;0;243;0
WireConnection;188;0;182;0
WireConnection;110;0;119;0
WireConnection;110;1;137;0
WireConnection;23;7;256;0
WireConnection;2;0;1;4
WireConnection;200;1;196;0
WireConnection;200;0;192;0
WireConnection;254;0;243;0
WireConnection;186;1;188;0
WireConnection;186;2;187;0
WireConnection;197;0;200;0
WireConnection;184;0;2;0
WireConnection;184;1;186;0
WireConnection;139;0;110;0
WireConnection;25;0;23;0
WireConnection;25;1;26;0
WireConnection;25;2;236;0
WireConnection;239;7;254;0
WireConnection;109;0;139;0
WireConnection;4;0;184;0
WireConnection;106;0;197;0
WireConnection;240;0;239;0
WireConnection;24;0;25;0
WireConnection;207;0;28;0
WireConnection;0;0;10;0
WireConnection;0;1;15;0
WireConnection;0;2;27;0
WireConnection;0;3;12;0
WireConnection;0;4;14;0
WireConnection;0;5;11;0
WireConnection;0;10;241;0
ASEEND*/
//CHKSM=B6A3B82459F93DFC90088314412CA024712242B4