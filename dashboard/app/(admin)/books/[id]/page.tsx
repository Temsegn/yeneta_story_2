"use client";

import { use } from "react";
import { ContentDetail } from "@/components/content/content-detail";

export default function BookDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  return <ContentDetail kind="books" id={id} />;
}
