"use client";

import { use } from "react";
import { ContentDetail } from "@/components/content/content-detail";

export default function EducationDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  return <ContentDetail kind="education" id={id} />;
}
