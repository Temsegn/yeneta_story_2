"use client";

import { use } from "react";
import { ContentDetail } from "@/components/content/content-detail";

export default function VideoDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  return <ContentDetail kind="videos" id={id} />;
}
